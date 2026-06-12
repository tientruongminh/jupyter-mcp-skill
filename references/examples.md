# Jupyter MCP Server - Quick Start Examples

## Example 1: Start Jupyter + Test Connection

```bash
# Terminal 1: Start Jupyter
pip install jupyterlab==4.4.1 jupyter-collaboration==4.0.2 jupyter-mcp-tools>=0.1.4 ipykernel pycrdt
jupyter lab --port 8888 --IdentityProvider.token test123 --ip 0.0.0.0

# Terminal 2: Test connection
cd ~/.openclaw/skills/jupyter-mcp
JUPYTER_URL=http://localhost:8888 JUPYTER_TOKEN=test123 bash scripts/test-connection.sh
```

## Example 2: Cursor MCP Config

Add to `~/.cursor/config.json` or Cursor settings:

```json
{
  "mcpServers": {
    "jupyter": {
      "command": "uvx",
      "args": ["jupyter-mcp-server@latest"],
      "env": {
        "JUPYTER_URL": "http://localhost:8888",
        "JUPYTER_TOKEN": "test123",
        "DOCUMENT_ID": "notebooks/analysis.ipynb",
        "ALLOW_IMG_OUTPUT": "true"
      }
    }
  }
}
```

## Example 3: Codex MCP Config

Add to `~/.codex/config.json`:

```json
{
  "mcp": {
    "servers": {
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
}
```

## Example 4: Claude Desktop Config

Add to `~/Library/Application Support/Claude/claude_desktop_config.json` (macOS) or `%APPDATA%/Claude/claude_desktop_config.json` (Windows):

```json
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

## Example 5: Spawn Codex Agent with Jupyter MCP

```python
# In OpenClaw session (assumes Codex has jupyter MCP configured)
sessions_spawn(
    runtime="acp",
    task="""
You have access to a Jupyter notebook via MCP tools.

Notebook: notebooks/data_analysis.ipynb

Task:
1. Read the notebook to understand current state
2. Fix the NameError in cell 5 (variable 'df' not defined)
3. Execute cells 5-10 to verify the fix
4. Add a new cell at the end with a summary visualization

Steps:
- Use read_notebook() to see all cells
- Use edit_cell_source() to fix the bug
- Use execute_cell() to run and verify
- Use insert_execute_code_cell() to add the visualization
    """,
    mode="run",
    agentId="codex"  # or "claude-code" depending on your setup
)
```

## Example 6: Agent Prompt Template

```markdown
You are working with a Jupyter notebook via MCP.

**Context:**
- Notebook path: notebooks/sales_analysis.ipynb
- Dataset: sales_data.csv (columns: date, product, revenue, region)
- Installed packages: pandas, matplotlib, seaborn
- Current directory: /home/user/projects/sales

**Your task:**
Perform exploratory data analysis:
1. Load the dataset into a DataFrame
2. Check for missing values and data types
3. Create 3 visualizations:
   - Revenue over time (line plot)
   - Revenue by region (bar chart)
   - Product distribution (pie chart)
4. Add markdown cells explaining each step

**Guidelines:**
- Read existing cells before making changes
- Use descriptive variable names
- Add comments to your code
- Execute cells after adding them to verify output
- Keep visualizations clean and labeled

**Available MCP tools:**
- read_notebook() - see all cells
- insert_cell() - add new cells
- execute_cell() - run cells
- read_cell() - inspect specific cell
```

## Example 7: Docker Deployment

```bash
# Start Jupyter in container
docker run -p 8888:8888 \
  -e JUPYTER_ENABLE_LAB=yes \
  -e JUPYTER_TOKEN=test123 \
  -v $(pwd)/notebooks:/home/jovyan/work \
  jupyter/scipy-notebook:latest

# MCP config (Linux)
{
  "mcpServers": {
    "jupyter": {
      "command": "docker",
      "args": [
        "run", "-i", "--rm",
        "-e", "JUPYTER_URL",
        "-e", "JUPYTER_TOKEN",
        "-e", "ALLOW_IMG_OUTPUT",
        "--network=host",
        "datalayer/jupyter-mcp-server:latest"
      ],
      "env": {
        "JUPYTER_URL": "http://localhost:8888",
        "JUPYTER_TOKEN": "test123",
        "ALLOW_IMG_OUTPUT": "true"
      }
    }
  }
}
```

## Example 8: Remote Jupyter Server

```json
{
  "mcpServers": {
    "jupyter": {
      "command": "uvx",
      "args": ["jupyter-mcp-server@latest"],
      "env": {
        "JUPYTER_URL": "https://jupyter.example.com",
        "JUPYTER_TOKEN": "your_remote_token",
        "DOCUMENT_ID": "projects/analysis.ipynb",
        "ALLOW_IMG_OUTPUT": "true"
      }
    }
  }
}
```

## Example 9: Multi-Notebook Workflow

```python
# Agent can switch between notebooks
sessions_spawn(
    runtime="acp",
    task="""
You have access to multiple notebooks via MCP.

Workflow:
1. Read data_cleaning.ipynb and run all cells
2. Switch to feature_engineering.ipynb
3. Load the cleaned data from step 1
4. Create 5 new features based on domain knowledge
5. Switch to model_training.ipynb
6. Train a model using the engineered features
7. Document results in summary.ipynb

Use these tools:
- list_notebooks() - see all available notebooks
- use_notebook(path) - switch to a notebook
- read_notebook() - understand current notebook
- execute_cell() - run cells
- insert_execute_code_cell() - add and run new code
    """,
    mode="run",
    agentId="codex"
)
```

## Example 10: JupyterHub Integration

```bash
# Start JupyterHub (see skill documentation for full setup)
jupyterhub --ip 0.0.0.0 --port 8000

# MCP config for hub user
{
  "mcpServers": {
    "jupyter": {
      "command": "uvx",
      "args": ["jupyter-mcp-server@latest"],
      "env": {
        "JUPYTER_URL": "http://localhost:8000/user/username",
        "JUPYTER_TOKEN": "hub_api_token",
        "ALLOW_IMG_OUTPUT": "true"
      }
    }
  }
}
```
