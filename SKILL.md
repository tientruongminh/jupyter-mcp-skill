# Jupyter MCP Server Skill

Control Jupyter Notebooks through Model Context Protocol (MCP) using the datalayer/jupyter-mcp-server.

## When to Use

Use this skill when:
- Agents (Codex, Claude Code, etc.) need to work with Jupyter notebooks
- You want to read/edit/execute notebook cells programmatically
- You need real-time notebook manipulation without manual conversion
- Working with data science workflows requiring notebook interaction

**NOT for:**
- Simple notebook → script conversion (use jupytext/nbconvert directly)
- One-off notebook execution (use `jupyter nbconvert --execute`)
- Manual notebook editing (use Jupyter UI)

## Prerequisites

1. **Running Jupyter Server** (JupyterLab 4.4.1+ recommended)
2. **uv** installed (`~/.local/bin/uv` or `~/.local/bin/uvx`)
3. **Jupyter token** for authentication

## Architecture

```
Agent (Cursor/Codex/Claude Code)
    ↓
MCP Client (spawned via sessions_spawn with runtime="acp")
    ↓
jupyter-mcp-server (via uvx)
    ↓
Jupyter Server API
    ↓
Notebook (.ipynb)
```

## Setup Jupyter Server

### Quick Start (Local)

```bash
# Install JupyterLab with real-time collaboration
pip install jupyterlab==4.4.1 jupyter-collaboration==4.0.2 jupyter-mcp-tools>=0.1.4 ipykernel pycrdt

# Start server
jupyter lab --port 8888 --IdentityProvider.token MY_TOKEN --ip 0.0.0.0
```

### Verify Setup

Open a notebook and type content in a cell. You should see:
- Tab shows "×" (unsaved)
- After ~2 seconds, "×" changes to "●" (auto-saved)

This confirms real-time collaboration is working.

## MCP Server Configuration

The server is run via `uvx jupyter-mcp-server@latest` with environment variables:

### Required Environment Variables

```bash
JUPYTER_URL=http://localhost:8888       # Jupyter server URL
JUPYTER_TOKEN=MY_TOKEN                  # Authentication token
```

### Optional Environment Variables

```bash
DOCUMENT_ID=notebooks/analysis.ipynb    # Default notebook to open
ALLOW_IMG_OUTPUT=true                   # Enable image/plot outputs (default: true)
DOCUMENT_URL=http://localhost:8888      # Separate document server (if different)
RUNTIME_URL=http://localhost:8888       # Separate runtime server (if different)
DOCUMENT_TOKEN=token1                   # Separate document token (if different)
RUNTIME_TOKEN=token2                    # Separate runtime token (if different)
```

## Available Tools

### File & Kernel Management
- `list_files` — List files/directories in Jupyter filesystem
- `list_kernels` — List available and running kernels
- `connect_to_jupyter` — Connect to Jupyter server dynamically

### Notebook Lifecycle
- `use_notebook` — Connect to notebook, create new, or switch between notebooks
- `list_notebooks` — List all notebooks and their status
- `restart_notebook` — Restart kernel for a notebook
- `unuse_notebook` — Disconnect from notebook and release resources
- `read_notebook` — Read all cells (brief or detailed format)

### Cell Operations
- `read_cell` — Read full content (metadata, source, outputs) of one cell
- `insert_cell` — Insert new code/markdown cell at position
- `delete_cell` — Delete cell at index
- `move_cell` — Move cell from one position to another
- `overwrite_cell_source` — Replace cell source entirely
- `edit_cell_source` — Surgical find-and-replace edits
- `execute_cell` — Execute cell with timeout, returns multimodal output
- `insert_execute_code_cell` — Insert + execute in one step
- `execute_code` — Execute code directly in kernel (supports magic commands)

### JupyterLab Integration (when enabled)
- `notebook_run-all-cells` — Execute all cells sequentially
- `notebook_get-selected-cell` — Get currently selected cell info

## Prompts

- `jupyter-cite` — Cite specific cells from notebook (like @ in IDEs)

## Usage Pattern

### 1. Start Jupyter Server

```bash
jupyter lab --port 8888 --IdentityProvider.token MY_TOKEN
```

### 2. Spawn ACP Agent with MCP

Use `sessions_spawn` with `runtime="acp"` and configure MCP in the agent's config.

Example for Cursor/Codex:

```bash
# In agent config (e.g., ~/.codex/config.json or cursor settings)
{
  "mcpServers": {
    "jupyter": {
      "command": "uvx",
      "args": ["jupyter-mcp-server@latest"],
      "env": {
        "JUPYTER_URL": "http://localhost:8888",
        "JUPYTER_TOKEN": "MY_TOKEN",
        "ALLOW_IMG_OUTPUT": "true"
      }
    }
  }
}
```

### 3. Agent Instructions

Provide clear context to the agent:

```
You have access to a Jupyter notebook server via MCP.

Current notebook: notebooks/analysis.ipynb

Tasks:
1. Read all cells to understand current state
2. Fix the bug in cell 5 (NameError on variable 'df')
3. Execute cells 5-8 to verify the fix
4. Add a new cell at the end with a summary plot

Use these tools:
- read_notebook() to see all cells
- edit_cell_source() for surgical edits
- execute_cell() to run and check outputs
- insert_execute_code_cell() to add new code
```

## Best Practices

### For Agents

1. **Read before writing** — Always `read_notebook()` or `read_cell()` first
2. **Surgical edits** — Use `edit_cell_source()` for small fixes, not `overwrite_cell_source()`
3. **Execute to verify** — Run `execute_cell()` after changes to catch errors
4. **Context awareness** — Read surrounding cells to understand data flow
5. **Multimodal outputs** — Check for images/plots in cell outputs

### For Prompts

1. **Break down tasks** — Split complex workflows into steps
2. **Provide context** — Mention installed packages, dataset fields, current directory
3. **Set expectations** — Clarify what "done" looks like
4. **Iterate** — Let agent read → edit → execute → verify in loops

### For Error Handling

- Always set `timeout` on `execute_cell()` (default 30s)
- Check `success` field in execution results
- Parse `error.ename`, `error.evalue`, `error.traceback` for debugging

## Security Notes

1. **Arbitrary code execution** — Agents can run any Python code in your kernel
2. **User consent required** — Review agent actions before execution
3. **Token protection** — Never expose `JUPYTER_TOKEN` in logs/commits
4. **Filesystem access** — MCP server inherits Jupyter's filesystem permissions

## Troubleshooting

### Connection Issues

```bash
# Test Jupyter API manually
curl -H "Authorization: token MY_TOKEN" http://localhost:8888/api

# Check if jupyter-mcp-server can connect
uvx jupyter-mcp-server@latest --help
```

### Auto-save Not Working

- Verify `jupyter-collaboration` is installed: `pip show jupyter-collaboration`
- Check JupyterLab version: `jupyter lab --version` (should be 4.4.1+)
- Restart JupyterLab server

### Image Outputs Not Showing

- Set `ALLOW_IMG_OUTPUT=true`
- Ensure agent/client supports multimodal (e.g., Gemini 2.5 Pro, Claude with vision)
- Check MCP client can parse base64 image data

## References

- [jupyter-mcp-server GitHub](https://github.com/datalayer/jupyter-mcp-server)
- [Official Documentation](https://jupyter-mcp-server.datalayer.tech/)
- [MCP Specification](https://modelcontextprotocol.io/)
- [Tools Reference](https://jupyter-mcp-server.datalayer.tech/tools)

## Example: Spawn Codex with Jupyter MCP

```python
# In OpenClaw session
sessions_spawn(
    runtime="acp",
    task="Fix the data cleaning bug in notebooks/analysis.ipynb cell 5",
    mode="run",
    # Agent will use MCP config from its own settings
    # Make sure Codex/Cursor has jupyter MCP server configured
)
```

## Example: Manual Test (without agent)

```bash
# Start Jupyter
jupyter lab --port 8888 --IdentityProvider.token test123

# In another terminal, test MCP server
export JUPYTER_URL=http://localhost:8888
export JUPYTER_TOKEN=test123
export ALLOW_IMG_OUTPUT=true

uvx jupyter-mcp-server@latest
# Server will start and wait for MCP client connections
```

---

**Status:** Production-ready  
**Maintainer:** Datalayer  
**Last Updated:** 2026-06-12
