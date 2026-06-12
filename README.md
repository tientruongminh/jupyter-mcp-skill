# Jupyter MCP Server Skill

**Version:** 1.0.0  
**Created:** 2026-06-12  
**Status:** Production-ready  
**Provider:** datalayer/jupyter-mcp-server

## Overview

Control Jupyter Notebooks through Model Context Protocol (MCP), enabling AI agents to read, edit, and execute notebook cells programmatically.

## Quick Links

- [SKILL.md](./SKILL.md) — Full documentation
- [examples.md](./references/examples.md) — Usage examples
- [tools.md](./references/tools.md) — Complete tools reference
- [test-connection.sh](./scripts/test-connection.sh) — Connection test script

## Quick Start

```bash
# 1. Install dependencies
pip install jupyterlab==4.4.1 jupyter-collaboration==4.0.2 jupyter-mcp-tools>=0.1.4 ipykernel pycrdt

# 2. Start Jupyter
jupyter lab --port 8888 --IdentityProvider.token test123

# 3. Test connection
cd ~/.openclaw/skills/jupyter-mcp
JUPYTER_URL=http://localhost:8888 JUPYTER_TOKEN=test123 bash scripts/test-connection.sh

# 4. Configure MCP client (e.g., Cursor/Codex)
# Add to client config:
{
  "mcpServers": {
    "jupyter": {
      "command": "uvx",
      "args": ["jupyter-mcp-server@latest"],
      "env": {
        "JUPYTER_URL": "http://localhost:8888",
        "JUPYTER_TOKEN": "test123",
        "ALLOW_IMG_OUTPUT": "true"
      }
    }
  }
}
```

## Key Features

- ⚡ Real-time notebook control
- 🔁 Smart cell execution with error feedback
- 🧠 Context-aware operations
- 📊 Multimodal output support (images, plots)
- 📚 Multi-notebook management
- 🎨 JupyterLab integration
- 🤝 Works with Cursor, Codex, Claude Desktop, Windsurf

## Main Tools

### Notebook Lifecycle
- `use_notebook` — Open/create/switch notebooks
- `list_notebooks` — See all available notebooks
- `read_notebook` — Read all cells

### Cell Operations
- `read_cell` — Read specific cell
- `insert_cell` — Add new cell
- `edit_cell_source` — Surgical edits
- `execute_cell` — Run cell and get outputs
- `insert_execute_code_cell` — Add + run in one step

### File & Kernel
- `list_files` — Browse Jupyter filesystem
- `list_kernels` — See available kernels
- `restart_notebook` — Restart kernel

## Usage with OpenClaw

```python
# Spawn Codex agent with Jupyter MCP access
sessions_spawn(
    runtime="acp",
    task="""
You have access to Jupyter via MCP.

Fix the bug in notebooks/analysis.ipynb cell 5:
1. Read the notebook
2. Find the NameError
3. Fix it
4. Execute to verify
    """,
    mode="run",
    agentId="codex"
)
```

## Environment Variables

Required:
- `JUPYTER_URL` — Jupyter server URL (e.g., http://localhost:8888)
- `JUPYTER_TOKEN` — Authentication token

Optional:
- `DOCUMENT_ID` — Default notebook path
- `ALLOW_IMG_OUTPUT` — Enable image outputs (default: true)

## Security Notes

⚠️ **Arbitrary code execution** — Agents can run any Python code in your kernel  
⚠️ **User consent required** — Review agent actions before execution  
⚠️ **Token protection** — Never expose JUPYTER_TOKEN in logs/commits

## Troubleshooting

### Connection fails
```bash
# Test API manually
curl -H "Authorization: token YOUR_TOKEN" http://localhost:8888/api
```

### Auto-save not working
```bash
# Check dependencies
pip show jupyter-collaboration
jupyter lab --version  # should be 4.4.1+
```

### Images not showing
- Set `ALLOW_IMG_OUTPUT=true`
- Use multimodal-capable LLM (Gemini 2.5 Pro, Claude with vision)

## Resources

- [GitHub](https://github.com/datalayer/jupyter-mcp-server)
- [Documentation](https://jupyter-mcp-server.datalayer.tech/)
- [MCP Specification](https://modelcontextprotocol.io/)

---

Made with ❤️ by Datalayer | Skill by OpenClaw
