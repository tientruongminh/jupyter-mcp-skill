# Jupyter MCP Server Skill

**Version:** 1.0.0  
**Created:** 2026-06-12  
**Status:** Production-ready (60+ tools)  
**Provider:** datalayer/jupyter-mcp-server

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub](https://img.shields.io/badge/GitHub-jupyter--mcp--skill-blue)](https://github.com/tientruongminh/jupyter-mcp-skill)

## Overview

Control Jupyter Notebooks through Model Context Protocol (MCP), enabling AI agents to read, edit, and execute notebook cells programmatically.

**60+ tools available:** Basic CRUD operations + advanced features for search, analytics, validation, refactoring, and more.

## Quick Links

- [SKILL.md](./SKILL.md) — Full documentation
- [examples.md](./references/examples.md) — 10 usage examples
- [tools.md](./references/tools.md) — Basic tools reference (20 tools)
- [advanced-features.md](./references/advanced-features.md) — Extended tools reference (40+ tools)
- [test-connection.sh](./scripts/test-connection.sh) — Connection test script
- [CONTRIBUTING.md](./CONTRIBUTING.md) — How to contribute
- [CHANGELOG.md](./CHANGELOG.md) — Version history

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

### Basic Operations (20 tools)
- ⚡ Real-time notebook control
- 🔁 Smart cell execution with error feedback
- 🧠 Context-aware operations
- 📊 Multimodal output support (images, plots)
- 📚 Multi-notebook management
- 🎨 JupyterLab integration

### Advanced Features (40+ tools)
- 🔍 **Smart Search**: Find cells by pattern, errors, outputs, variables
- 📈 **Analytics**: Execution time, memory usage, performance profiling
- ✅ **Validation**: Check reproducibility, undefined variables, execution order
- 🔄 **Refactoring**: Extract functions, merge/split cells, batch edits
- 📝 **Annotations**: Flag cells, add TODOs, track changes
- 🧪 **Testing**: Output baselines, regression testing, comparison
- 🎯 **Section Management**: Work with markdown sections
- 🛠️ **Templates**: Auto-generate DataFrame inspection, plots, error handling
- 🔬 **Kernel Inspection**: List variables, check types, analyze dependencies
- ⚙️ **Magic Commands**: %%timeit, %%prun, %%debug

### Agent Compatibility
- 🤝 Works with Cursor, Codex, Claude Desktop, Windsurf, Claude Code
- 🚀 OpenClaw integration via sessions_spawn
- 🔌 Standard MCP protocol

## Main Tools

### Basic Operations
**Notebook Lifecycle**
- `use_notebook` — Open/create/switch notebooks
- `list_notebooks` — See all available notebooks
- `read_notebook` — Read all cells

**Cell Operations**
- `read_cell` — Read specific cell
- `insert_cell` — Add new cell
- `edit_cell_source` — Surgical edits
- `execute_cell` — Run cell and get outputs
- `insert_execute_code_cell` — Add + run in one step

**File & Kernel**
- `list_files` — Browse Jupyter filesystem
- `list_kernels` — See available kernels
- `restart_notebook` — Restart kernel

### Advanced Features
**Smart Analysis**
- `find_cells` — Search by pattern/errors/outputs
- `get_cell_dependencies` — Analyze variable flow
- `validate_notebook` — Check for issues
- `check_reproducibility` — Test clean execution

**Performance & Debugging**
- `get_slowest_cells` — Find bottlenecks
- `timeit_cell` — Benchmark execution
- `profile_cell` — Profile performance
- `get_cell_memory_usage` — Memory analysis

**Productivity**
- `annotate_cell` — Add notes/TODOs
- `flag_cell` — Mark for review
- `extract_to_function` — Refactor to functions
- `batch_edit_cells` — Edit multiple cells
- `execute_section` — Run entire sections

**Templates & Helpers**
- `insert_dataframe_inspect_cell` — Auto DataFrame inspection
- `insert_plot_cell` — Auto visualization code
- `insert_cell_after_imports` — Smart positioning
- `insert_error_handling_cell` — Wrap in try/except

**Testing & Validation**
- `compare_cell_outputs` — Compare runs
- `save_cell_output_baseline` — Regression testing
- `check_cell_variables` — Catch undefined vars

See [advanced-features.md](./references/advanced-features.md) for complete documentation.

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
