# Jupyter MCP Tools Reference

Complete reference for all tools provided by jupyter-mcp-server.

## File & Kernel Management

### list_files

List files and directories in the Jupyter server's file system.

**Parameters:**
- `path` (string, optional): Directory path to list. Default: root directory

**Returns:**
```json
{
  "files": [
    {
      "name": "notebook.ipynb",
      "path": "notebooks/notebook.ipynb",
      "type": "notebook",
      "size": 12345,
      "last_modified": "2026-06-12T21:00:00Z"
    }
  ]
}
```

### list_kernels

List all available and running kernel sessions on the Jupyter server.

**Parameters:** None

**Returns:**
```json
{
  "kernels": [
    {
      "id": "abc-123",
      "name": "python3",
      "last_activity": "2026-06-12T21:00:00Z",
      "connections": 1,
      "execution_state": "idle"
    }
  ]
}
```

### connect_to_jupyter

Connect to a Jupyter server dynamically without restarting the MCP server.

**Parameters:**
- `url` (string, required): Jupyter server URL
- `token` (string, required): Authentication token

**Returns:**
```json
{
  "success": true,
  "message": "Connected to Jupyter server"
}
```

**Note:** Not available when running as Jupyter extension.

---

## Notebook Lifecycle

### use_notebook

Connect to a notebook file, create a new one, or switch between notebooks.

**Parameters:**
- `path` (string, required): Notebook path relative to Jupyter root
- `create` (boolean, optional): Create if doesn't exist. Default: false

**Returns:**
```json
{
  "success": true,
  "path": "notebooks/analysis.ipynb",
  "kernel": {
    "id": "abc-123",
    "name": "python3",
    "state": "idle"
  }
}
```

### list_notebooks

List all notebooks available on the Jupyter server and their status.

**Parameters:** None

**Returns:**
```json
{
  "notebooks": [
    {
      "path": "notebooks/analysis.ipynb",
      "name": "analysis.ipynb",
      "last_modified": "2026-06-12T21:00:00Z",
      "kernel": "python3",
      "status": "active"
    }
  ]
}
```

### restart_notebook

Restart the kernel for a specific managed notebook.

**Parameters:**
- `path` (string, required): Notebook path

**Returns:**
```json
{
  "success": true,
  "message": "Kernel restarted",
  "kernel_id": "new-abc-123"
}
```

### unuse_notebook

Disconnect from a specific notebook and release its resources.

**Parameters:**
- `path` (string, required): Notebook path

**Returns:**
```json
{
  "success": true,
  "message": "Disconnected from notebook"
}
```

### read_notebook

Read notebook cells source content with brief or detailed format options.

**Parameters:**
- `path` (string, optional): Notebook path (uses current if omitted)
- `format` (string, optional): "brief" or "detailed". Default: "brief"

**Returns (brief):**
```json
{
  "cells": [
    {
      "index": 0,
      "type": "code",
      "source": "import pandas as pd\ndf = pd.read_csv('data.csv')",
      "execution_count": 1
    }
  ]
}
```

**Returns (detailed):**
```json
{
  "cells": [
    {
      "index": 0,
      "type": "code",
      "source": "import pandas as pd",
      "execution_count": 1,
      "metadata": {},
      "outputs": [
        {
          "output_type": "stream",
          "name": "stdout",
          "text": "Hello"
        }
      ]
    }
  ]
}
```

---

## Cell Operations

### read_cell

Read the full content (Metadata, Source and Outputs) of a single cell.

**Parameters:**
- `index` (integer, required): Cell index (0-based)
- `path` (string, optional): Notebook path (uses current if omitted)

**Returns:**
```json
{
  "index": 5,
  "type": "code",
  "source": "print('Hello World')",
  "execution_count": 3,
  "metadata": {},
  "outputs": [
    {
      "output_type": "stream",
      "name": "stdout",
      "text": "Hello World\n"
    }
  ]
}
```

### insert_cell

Insert a new code or markdown cell at a specified position.

**Parameters:**
- `index` (integer, required): Position to insert (0-based)
- `cell_type` (string, required): "code" or "markdown"
- `source` (string, required): Cell content
- `path` (string, optional): Notebook path

**Returns:**
```json
{
  "success": true,
  "index": 5,
  "message": "Cell inserted at index 5"
}
```

### delete_cell

Delete a cell at a specified index.

**Parameters:**
- `index` (integer, required): Cell index to delete
- `path` (string, optional): Notebook path

**Returns:**
```json
{
  "success": true,
  "message": "Cell 5 deleted"
}
```

### move_cell

Move a cell from one position to another within a notebook.

**Parameters:**
- `from_index` (integer, required): Source index
- `to_index` (integer, required): Destination index
- `path` (string, optional): Notebook path

**Returns:**
```json
{
  "success": true,
  "message": "Cell moved from 3 to 7"
}
```

### overwrite_cell_source

Overwrite the source code of an existing cell.

**Parameters:**
- `index` (integer, required): Cell index
- `source` (string, required): New cell content
- `path` (string, optional): Notebook path

**Returns:**
```json
{
  "success": true,
  "message": "Cell 5 source overwritten"
}
```

### edit_cell_source

Apply surgical find-and-replace edits to a cell's source without full rewrite.

**Parameters:**
- `index` (integer, required): Cell index
- `find` (string, required): Text to find
- `replace` (string, required): Replacement text
- `path` (string, optional): Notebook path

**Returns:**
```json
{
  "success": true,
  "message": "Cell 5 edited: 1 replacement made"
}
```

### execute_cell

Execute a cell with timeout, supports multimodal output including images.

**Parameters:**
- `index` (integer, required): Cell index
- `timeout` (integer, optional): Timeout in seconds. Default: 30
- `path` (string, optional): Notebook path

**Returns (success):**
```json
{
  "success": true,
  "execution_count": 10,
  "outputs": [
    {
      "output_type": "stream",
      "name": "stdout",
      "text": "Result: 42\n"
    },
    {
      "output_type": "display_data",
      "data": {
        "image/png": "iVBORw0KGgoAAAANS...",
        "text/plain": "<Figure size 640x480 with 1 Axes>"
      },
      "metadata": {}
    }
  ]
}
```

**Returns (error):**
```json
{
  "success": false,
  "error": {
    "ename": "NameError",
    "evalue": "name 'undefined_var' is not defined",
    "traceback": [
      "Traceback (most recent call last):",
      "  File \"<stdin>\", line 1, in <module>",
      "NameError: name 'undefined_var' is not defined"
    ]
  }
}
```

### insert_execute_code_cell

Insert a new code cell and execute it in one step.

**Parameters:**
- `index` (integer, required): Position to insert
- `source` (string, required): Code to execute
- `timeout` (integer, optional): Timeout in seconds. Default: 30
- `path` (string, optional): Notebook path

**Returns:**
```json
{
  "success": true,
  "index": 8,
  "execution_count": 11,
  "outputs": [...]
}
```

### execute_code

Execute code directly in the kernel, supports magic commands and shell commands.

**Parameters:**
- `code` (string, required): Code to execute
- `timeout` (integer, optional): Timeout in seconds. Default: 30
- `path` (string, optional): Notebook path (for kernel context)

**Returns:**
```json
{
  "success": true,
  "outputs": [
    {
      "output_type": "stream",
      "name": "stdout",
      "text": "Output from code execution\n"
    }
  ]
}
```

**Examples:**
```python
# Regular Python
execute_code(code="import numpy as np\nprint(np.__version__)")

# Magic commands
execute_code(code="%timeit sum(range(1000))")

# Shell commands
execute_code(code="!ls -la")
```

---

## JupyterLab Integration Tools

Available only when JupyterLab mode is enabled (default).

### notebook_run-all-cells

Execute all cells in the current notebook sequentially.

**Parameters:**
- `path` (string, optional): Notebook path

**Returns:**
```json
{
  "success": true,
  "executed": 15,
  "message": "All 15 cells executed"
}
```

### notebook_get-selected-cell

Get information about the currently selected cell in JupyterLab UI.

**Parameters:** None

**Returns:**
```json
{
  "index": 5,
  "type": "code",
  "source": "df.head()",
  "execution_count": 3
}
```

---

## Output Types Reference

Cell execution can return various output types:

### stream
```json
{
  "output_type": "stream",
  "name": "stdout",  // or "stderr"
  "text": "Output text\n"
}
```

### display_data (images, plots)
```json
{
  "output_type": "display_data",
  "data": {
    "image/png": "base64_encoded_image_data",
    "text/plain": "<Figure size 640x480>"
  },
  "metadata": {}
}
```

### execute_result
```json
{
  "output_type": "execute_result",
  "execution_count": 5,
  "data": {
    "text/plain": "42",
    "text/html": "<div>...</div>"
  },
  "metadata": {}
}
```

### error
```json
{
  "output_type": "error",
  "ename": "ValueError",
  "evalue": "invalid value",
  "traceback": [...]
}
```

---

## Error Handling

All tools return error responses in this format:

```json
{
  "success": false,
  "error": {
    "type": "NotebookNotFound",
    "message": "Notebook 'missing.ipynb' not found",
    "details": "..."
  }
}
```

Common error types:
- `NotebookNotFound` — Notebook path doesn't exist
- `CellIndexError` — Invalid cell index
- `KernelError` — Kernel not available or crashed
- `ExecutionTimeout` — Cell execution exceeded timeout
- `AuthenticationError` — Invalid token
- `ConnectionError` — Cannot reach Jupyter server

---

## Best Practices

1. **Always check success field** before processing results
2. **Set appropriate timeouts** for long-running cells
3. **Use edit_cell_source** for small changes, not overwrite_cell_source
4. **Read before write** — understand context before modifying
5. **Handle multimodal outputs** — check for image/png, text/html, etc.
6. **Verify execution** — check outputs after execute_cell
7. **Release resources** — call unuse_notebook when done
