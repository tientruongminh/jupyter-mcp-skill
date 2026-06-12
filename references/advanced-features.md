# Advanced Notebook Interaction Features

Extended features for deep notebook interaction beyond basic CRUD operations.

## 1. Cell Diff & History

### diff_cell

Compare cell versions and track changes.

**Parameters:**
- `index` (integer, required): Cell index
- `show_history` (boolean, optional): Show full edit history. Default: false
- `path` (string, optional): Notebook path

**Returns:**
```json
{
  "cell_index": 5,
  "current_source": "df = pd.read_csv('data.csv')",
  "previous_source": "df = pd.read_csv('old_data.csv')",
  "diff": [
    {"type": "delete", "line": 1, "content": "df = pd.read_csv('old_data.csv')"},
    {"type": "add", "line": 1, "content": "df = pd.read_csv('data.csv')"}
  ],
  "history": [
    {
      "timestamp": "2026-06-12T20:00:00Z",
      "source": "df = pd.read_csv('data.csv')",
      "execution_count": 3
    }
  ]
}
```

### rollback_cell

Restore cell to a previous version.

**Parameters:**
- `index` (integer, required): Cell index
- `version` (integer, optional): Version to restore (-1 = previous, -2 = two versions back). Default: -1
- `path` (string, optional): Notebook path

**Returns:**
```json
{
  "success": true,
  "message": "Cell 5 rolled back to version -1",
  "restored_source": "df = pd.read_csv('old_data.csv')"
}
```

---

## 2. Smart Cell Search

### find_cells

Search cells by content, type, or output characteristics.

**Parameters:**
- `pattern` (string, optional): Regex pattern to search in cell source
- `cell_type` (string, optional): "code" or "markdown"
- `contains_error` (boolean, optional): Find cells with execution errors
- `has_output_type` (string, optional): "image/png", "text/html", etc.
- `variable_name` (string, optional): Find cells that define/use this variable
- `path` (string, optional): Notebook path

**Returns:**
```json
{
  "matches": [
    {
      "index": 3,
      "type": "code",
      "source": "import pandas as pd",
      "match_reason": "pattern: 'import pandas'",
      "execution_count": 1
    },
    {
      "index": 12,
      "type": "code",
      "source": "df = pd.DataFrame(...)",
      "match_reason": "pattern: 'import pandas' in imports",
      "execution_count": 5
    }
  ],
  "total": 2
}
```

**Examples:**
```python
# Find import cells
find_cells(pattern="^import ", cell_type="code")

# Find cells with errors
find_cells(contains_error=True)

# Find cells with plots
find_cells(has_output_type="image/png")

# Find cells using variable 'df'
find_cells(variable_name="df")
```

---

## 3. Cell Dependencies Graph

### get_cell_dependencies

Analyze which previous cells a given cell depends on (variable flow).

**Parameters:**
- `index` (integer, required): Cell index
- `path` (string, optional): Notebook path

**Returns:**
```json
{
  "cell_index": 5,
  "depends_on": [
    {
      "cell_index": 2,
      "variables": ["df", "config"]
    },
    {
      "cell_index": 3,
      "variables": ["preprocessor"]
    }
  ],
  "undefined_variables": ["unknown_var"]
}
```

### get_affected_cells

Find which cells would be affected if a cell changes.

**Parameters:**
- `index` (integer, required): Cell index
- `path` (string, optional): Notebook path

**Returns:**
```json
{
  "cell_index": 3,
  "affects": [
    {
      "cell_index": 5,
      "variables_used": ["df"]
    },
    {
      "cell_index": 7,
      "variables_used": ["df", "preprocessor"]
    }
  ],
  "total_affected": 2
}
```

---

## 4. Batch Cell Operations

### execute_cells

Execute multiple cells in sequence.

**Parameters:**
- `indices` (array[integer], required): Cell indices to execute
- `stop_on_error` (boolean, optional): Stop if any cell fails. Default: true
- `timeout` (integer, optional): Timeout per cell in seconds. Default: 30
- `path` (string, optional): Notebook path

**Returns:**
```json
{
  "success": true,
  "results": [
    {
      "index": 1,
      "success": true,
      "execution_count": 10,
      "duration_ms": 250
    },
    {
      "index": 2,
      "success": false,
      "error": {
        "ename": "NameError",
        "evalue": "name 'x' is not defined"
      }
    }
  ],
  "executed": 2,
  "failed": 1
}
```

### batch_edit_cells

Edit multiple cells at once.

**Parameters:**
- `edits` (array[object], required): Array of edit operations
  - Each edit: `{"index": int, "find": str, "replace": str}`
- `path` (string, optional): Notebook path

**Returns:**
```json
{
  "success": true,
  "results": [
    {
      "index": 1,
      "replacements": 1,
      "success": true
    },
    {
      "index": 3,
      "replacements": 2,
      "success": true
    }
  ],
  "total_edits": 2
}
```

---

## 5. Cell Output Filtering

### get_cell_output

Get specific output types from a cell.

**Parameters:**
- `index` (integer, required): Cell index
- `output_type` (string, required): "image/png", "text/html", "stream", "execute_result"
- `stream_name` (string, optional): For output_type="stream": "stdout" or "stderr"
- `path` (string, optional): Notebook path

**Returns:**
```json
{
  "cell_index": 5,
  "output_type": "image/png",
  "data": "iVBORw0KGgoAAAANSUhEUgAA...",
  "metadata": {
    "width": 640,
    "height": 480
  }
}
```

### get_dataframe_output

Extract pandas DataFrame from cell output.

**Parameters:**
- `index` (integer, required): Cell index
- `format` (string, optional): "json", "csv", "html". Default: "json"
- `path` (string, optional): Notebook path

**Returns:**
```json
{
  "cell_index": 7,
  "dataframe": {
    "columns": ["name", "age", "city"],
    "data": [
      ["Alice", 25, "NYC"],
      ["Bob", 30, "SF"]
    ],
    "shape": [2, 3],
    "dtypes": {
      "name": "object",
      "age": "int64",
      "city": "object"
    }
  }
}
```

---

## 6. Cell Annotations & Comments

### annotate_cell

Add inline notes/comments to a cell.

**Parameters:**
- `index` (integer, required): Cell index
- `note` (string, required): Annotation text
- `type` (string, optional): "todo", "fixme", "note", "warning". Default: "note"
- `path` (string, optional): Notebook path

**Returns:**
```json
{
  "success": true,
  "cell_index": 5,
  "annotation": {
    "type": "todo",
    "note": "Optimize this loop",
    "timestamp": "2026-06-12T21:30:00Z"
  }
}
```

### get_cell_annotations

Get all annotations for a cell.

**Parameters:**
- `index` (integer, required): Cell index
- `path` (string, optional): Notebook path

**Returns:**
```json
{
  "cell_index": 5,
  "annotations": [
    {
      "type": "todo",
      "note": "Optimize this loop",
      "timestamp": "2026-06-12T21:30:00Z"
    }
  ]
}
```

### flag_cell

Mark a cell for review.

**Parameters:**
- `index` (integer, required): Cell index
- `reason` (string, required): Why flagged
- `priority` (string, optional): "low", "medium", "high". Default: "medium"
- `path` (string, optional): Notebook path

**Returns:**
```json
{
  "success": true,
  "cell_index": 3,
  "flag": {
    "reason": "produces wrong result",
    "priority": "high",
    "timestamp": "2026-06-12T21:30:00Z"
  }
}
```

### list_flagged_cells

Get all flagged cells in a notebook.

**Parameters:**
- `path` (string, optional): Notebook path

**Returns:**
```json
{
  "flagged_cells": [
    {
      "index": 3,
      "reason": "produces wrong result",
      "priority": "high",
      "timestamp": "2026-06-12T21:30:00Z"
    }
  ],
  "total": 1
}
```

---

## 7. Cell Execution Analytics

### get_cell_execution_time

Get execution duration for a cell.

**Parameters:**
- `index` (integer, required): Cell index
- `path` (string, optional): Notebook path

**Returns:**
```json
{
  "cell_index": 5,
  "execution_time_ms": 2345,
  "execution_time_human": "2.3s",
  "last_executed": "2026-06-12T21:25:00Z"
}
```

### get_slowest_cells

Find slowest-executing cells.

**Parameters:**
- `top` (integer, optional): Number of results. Default: 5
- `path` (string, optional): Notebook path

**Returns:**
```json
{
  "slowest_cells": [
    {
      "index": 12,
      "execution_time_ms": 45000,
      "execution_time_human": "45.0s",
      "source_preview": "model.fit(X_train, y_train)"
    },
    {
      "index": 8,
      "execution_time_ms": 12000,
      "execution_time_human": "12.0s",
      "source_preview": "df = pd.read_csv('large_file.csv')"
    }
  ]
}
```

### get_cell_memory_usage

Get memory usage of a cell.

**Parameters:**
- `index` (integer, required): Cell index
- `path` (string, optional): Notebook path

**Returns:**
```json
{
  "cell_index": 7,
  "memory_mb": 125.4,
  "memory_human": "125.4 MB",
  "variables": {
    "df": "85.2 MB",
    "model": "40.2 MB"
  }
}
```

---

## 8. Smart Cell Insertion

### insert_cell_after_imports

Insert cell after all import statements.

**Parameters:**
- `source` (string, required): Cell content
- `cell_type` (string, optional): "code" or "markdown". Default: "code"
- `path` (string, optional): Notebook path

**Returns:**
```json
{
  "success": true,
  "inserted_at": 4,
  "message": "Cell inserted after imports (last import at index 3)"
}
```

### insert_cell_before_plots

Insert cell before visualization cells.

**Parameters:**
- `source` (string, required): Cell content
- `path` (string, optional): Notebook path

**Returns:**
```json
{
  "success": true,
  "inserted_at": 15,
  "message": "Cell inserted before first plot cell (index 16)"
}
```

### insert_cleanup_cell

Add cell to clean up temporary variables.

**Parameters:**
- `variables` (array[string], optional): Variables to delete. Auto-detect if omitted.
- `path` (string, optional): Notebook path

**Returns:**
```json
{
  "success": true,
  "inserted_at": 25,
  "source": "del temp_var1, temp_var2, _intermediate_result",
  "cleaned_variables": ["temp_var1", "temp_var2", "_intermediate_result"]
}
```

---

## 9. Cell Templates

### insert_dataframe_inspect_cell

Insert cell with DataFrame inspection code.

**Parameters:**
- `df_var` (string, required): DataFrame variable name
- `index` (integer, required): Position to insert
- `path` (string, optional): Notebook path

**Returns:**
```json
{
  "success": true,
  "inserted_at": 8,
  "source": "# DataFrame Inspection\nprint(f'Shape: {df.shape}')\nprint(f'\\nInfo:')\ndf.info()\nprint(f'\\nFirst 5 rows:')\ndisplay(df.head())\nprint(f'\\nSummary statistics:')\ndisplay(df.describe())"
}
```

### insert_plot_cell

Insert cell with plotting code.

**Parameters:**
- `data_var` (string, required): Data variable name
- `x` (string, required): X-axis column
- `y` (string, required): Y-axis column
- `plot_type` (string, optional): "line", "bar", "scatter". Default: "line"
- `index` (integer, required): Position to insert
- `path` (string, optional): Notebook path

**Returns:**
```json
{
  "success": true,
  "inserted_at": 12,
  "source": "import matplotlib.pyplot as plt\nimport seaborn as sns\n\nplt.figure(figsize=(10, 6))\nsns.lineplot(data=df, x='date', y='revenue')\nplt.title('Revenue Over Time')\nplt.xlabel('Date')\nplt.ylabel('Revenue')\nplt.xticks(rotation=45)\nplt.tight_layout()\nplt.show()"
}
```

### insert_error_handling_cell

Wrap a cell in try/except error handling.

**Parameters:**
- `target_index` (integer, required): Cell to wrap
- `error_message` (string, optional): Custom error message
- `path` (string, optional): Notebook path

**Returns:**
```json
{
  "success": true,
  "modified_index": 5,
  "original_source": "result = risky_operation()",
  "new_source": "try:\n    result = risky_operation()\nexcept Exception as e:\n    print(f'Error in cell 5: {e}')\n    result = None"
}
```

---

## 10. Kernel Variable Inspection

### list_kernel_variables

List all variables in the kernel namespace.

**Parameters:**
- `filter_type` (string, optional): "user" (user-defined only) or "all". Default: "user"
- `path` (string, optional): Notebook path

**Returns:**
```json
{
  "variables": [
    {
      "name": "df",
      "type": "pandas.DataFrame",
      "size": "85.2 MB"
    },
    {
      "name": "model",
      "type": "sklearn.linear_model.LinearRegression",
      "size": "40.2 MB"
    },
    {
      "name": "config",
      "type": "dict",
      "size": "1.2 KB"
    }
  ],
  "total": 3
}
```

### get_variable_info

Get detailed info about a kernel variable.

**Parameters:**
- `var_name` (string, required): Variable name
- `path` (string, optional): Notebook path

**Returns:**
```json
{
  "name": "df",
  "type": "pandas.DataFrame",
  "shape": [1000, 15],
  "columns": ["id", "name", "age", "..."],
  "memory_mb": 85.2,
  "dtype_info": {
    "id": "int64",
    "name": "object",
    "age": "int64"
  }
}
```

### get_variable_value

Get the value of a kernel variable.

**Parameters:**
- `var_name` (string, required): Variable name
- `max_chars` (integer, optional): Truncate output. Default: 1000
- `format` (string, optional): "repr", "str", "json". Default: "repr"
- `path` (string, optional): Notebook path

**Returns:**
```json
{
  "name": "config",
  "value": "{'learning_rate': 0.001, 'epochs': 100, 'batch_size': 32}",
  "truncated": false
}
```

### check_cell_variables

Check for undefined/defined variables in a cell.

**Parameters:**
- `index` (integer, required): Cell index
- `path` (string, optional): Notebook path

**Returns:**
```json
{
  "cell_index": 5,
  "source": "result = df.groupby('category')[column].sum()",
  "undefined": ["column"],
  "defined": ["df", "result"],
  "warnings": [
    "Variable 'column' used but not defined in previous cells"
  ]
}
```

---

## 11. Notebook Validation

### validate_notebook

Check notebook health and common issues.

**Parameters:**
- `path` (string, optional): Notebook path

**Returns:**
```json
{
  "valid": false,
  "issues": [
    {
      "type": "execution_error",
      "cell_index": 5,
      "message": "Cell has execution error: NameError"
    },
    {
      "type": "undefined_variable",
      "cell_index": 7,
      "message": "Uses undefined variable 'x'"
    },
    {
      "type": "not_executed",
      "cell_index": 12,
      "message": "Cell has not been executed"
    },
    {
      "type": "out_of_order",
      "cell_index": 3,
      "message": "Executed out of order (execution_count: 10, previous: 2)"
    }
  ],
  "total_issues": 4,
  "cells_with_errors": 2,
  "cells_not_executed": 1,
  "execution_order_issues": 1
}
```

### check_reproducibility

Test if notebook runs cleanly from top to bottom.

**Parameters:**
- `timeout` (integer, optional): Total timeout in seconds. Default: 300
- `path` (string, optional): Notebook path

**Returns:**
```json
{
  "reproducible": true,
  "execution_summary": {
    "total_cells": 20,
    "executed": 20,
    "failed": 0,
    "skipped": 0,
    "total_time_ms": 45000
  },
  "output_comparison": {
    "cells_with_different_outputs": [],
    "cells_with_new_outputs": []
  }
}
```

---

## 12. Cell Output Comparison

### compare_cell_outputs

Compare outputs between two runs.

**Parameters:**
- `index` (integer, required): Cell index
- `run1_id` (string, required): First run identifier
- `run2_id` (string, required): Second run identifier
- `path` (string, optional): Notebook path

**Returns:**
```json
{
  "cell_index": 5,
  "outputs_match": false,
  "diff": {
    "run1": {
      "output_type": "stream",
      "text": "Result: 42\n"
    },
    "run2": {
      "output_type": "stream",
      "text": "Result: 43\n"
    },
    "difference": "Values differ: 42 vs 43"
  }
}
```

### save_cell_output_baseline

Save current output as baseline for future comparison.

**Parameters:**
- `index` (integer, required): Cell index
- `baseline_name` (string, optional): Baseline identifier. Default: "default"
- `path` (string, optional): Notebook path

**Returns:**
```json
{
  "success": true,
  "cell_index": 5,
  "baseline_name": "default",
  "saved_at": "2026-06-12T21:30:00Z"
}
```

### compare_with_baseline

Compare current output with saved baseline.

**Parameters:**
- `index` (integer, required): Cell index
- `baseline_name` (string, optional): Baseline identifier. Default: "default"
- `path` (string, optional): Notebook path

**Returns:**
```json
{
  "cell_index": 5,
  "matches_baseline": false,
  "baseline_name": "default",
  "diff": {
    "baseline": "Result: 42\n",
    "current": "Result: 43\n",
    "difference": "Output changed"
  }
}
```

---

## 13. Magic Command Helpers

### timeit_cell

Execute cell with %%timeit magic.

**Parameters:**
- `index` (integer, required): Cell index
- `number` (integer, optional): Number of runs. Default: 7
- `repeat` (integer, optional): Number of repeats. Default: 3
- `path` (string, optional): Notebook path

**Returns:**
```json
{
  "cell_index": 5,
  "timing_result": "234 µs ± 12.3 µs per loop (mean ± std. dev. of 3 runs, 7 loops each)",
  "mean_us": 234,
  "std_us": 12.3
}
```

### profile_cell

Execute cell with %%prun profiler.

**Parameters:**
- `index` (integer, required): Cell index
- `sort_by` (string, optional): "time", "cumulative", "calls". Default: "time"
- `top` (integer, optional): Number of results. Default: 10
- `path` (string, optional): Notebook path

**Returns:**
```json
{
  "cell_index": 5,
  "profile_results": [
    {
      "function": "pandas.DataFrame.groupby",
      "calls": 1,
      "time_ms": 125.4,
      "cumulative_ms": 230.5
    }
  ]
}
```

### debug_cell

Execute cell in debug mode.

**Parameters:**
- `index` (integer, required): Cell index
- `breakpoint_line` (integer, optional): Line to break at
- `path` (string, optional): Notebook path

**Returns:**
```json
{
  "cell_index": 5,
  "debug_session_started": true,
  "message": "Debug session active. Use debug commands to step through.",
  "variables_at_breakpoint": {
    "x": 10,
    "y": 20
  }
}
```

---

## 14. Cell Refactoring

### extract_to_function

Extract cell code into a reusable function.

**Parameters:**
- `index` (integer, required): Cell index
- `func_name` (string, required): Function name
- `params` (array[string], optional): Function parameters (auto-detect if omitted)
- `return_vars` (array[string], optional): Return variables (auto-detect if omitted)
- `path` (string, optional): Notebook path

**Returns:**
```json
{
  "success": true,
  "function_cell_index": 5,
  "updated_cell_index": 6,
  "function_source": "def process_data(df, config):\n    # Original cell code\n    result = df.groupby('category').sum()\n    return result",
  "call_source": "result = process_data(df, config)"
}
```

### merge_cells

Merge multiple consecutive cells into one.

**Parameters:**
- `indices` (array[integer], required): Cell indices to merge
- `separator` (string, optional): Code separator. Default: "\n\n"
- `path` (string, optional): Notebook path

**Returns:**
```json
{
  "success": true,
  "merged_index": 3,
  "deleted_indices": [4, 5],
  "merged_source": "# Cell 3\nimport pandas as pd\n\n# Cell 4\ndf = pd.read_csv('data.csv')\n\n# Cell 5\ndf.head()"
}
```

### split_cell

Split cell at a specific line.

**Parameters:**
- `index` (integer, required): Cell index
- `at_line` (integer, required): Line number to split at (1-indexed)
- `path` (string, optional): Notebook path

**Returns:**
```json
{
  "success": true,
  "first_cell_index": 5,
  "second_cell_index": 6,
  "first_cell_source": "import pandas as pd\nimport numpy as np",
  "second_cell_source": "df = pd.read_csv('data.csv')\ndf.head()"
}
```

---

## 15. Notebook Section Management

### list_sections

List all markdown section headers in notebook.

**Parameters:**
- `path` (string, optional): Notebook path

**Returns:**
```json
{
  "sections": [
    {
      "title": "Data Loading",
      "level": 1,
      "cell_index": 0
    },
    {
      "title": "Exploratory Data Analysis",
      "level": 1,
      "cell_index": 5
    },
    {
      "title": "Feature Engineering",
      "level": 2,
      "cell_index": 10
    }
  ],
  "total": 3
}
```

### get_section_cells

Get all cells belonging to a section.

**Parameters:**
- `section` (string, required): Section title
- `path` (string, optional): Notebook path

**Returns:**
```json
{
  "section": "Exploratory Data Analysis",
  "header_cell_index": 5,
  "cell_indices": [6, 7, 8, 9],
  "total_cells": 4
}
```

### execute_section

Execute all cells in a section.

**Parameters:**
- `section` (string, required): Section title
- `timeout` (integer, optional): Timeout per cell. Default: 30
- `path` (string, optional): Notebook path

**Returns:**
```json
{
  "success": true,
  "section": "Exploratory Data Analysis",
  "executed_cells": [6, 7, 8, 9],
  "total_executed": 4,
  "failed": 0,
  "total_time_ms": 3500
}
```

### insert_section_header

Insert a markdown section header.

**Parameters:**
- `title` (string, required): Section title
- `level` (integer, optional): Header level (1-6). Default: 1
- `after_index` (integer, required): Insert after this cell index
- `path` (string, optional): Notebook path

**Returns:**
```json
{
  "success": true,
  "inserted_at": 11,
  "source": "# Feature Engineering",
  "level": 1
}
```

---

## Usage Examples

### Example 1: Find and Fix Cells with Errors

```python
# Find all cells with errors
errors = find_cells(contains_error=True)

for cell in errors["matches"]:
    # Get cell dependencies
    deps = get_cell_dependencies(index=cell["index"])
    
    # Check for undefined variables
    var_check = check_cell_variables(index=cell["index"])
    
    # Flag for review
    flag_cell(
        index=cell["index"],
        reason=f"Undefined: {var_check['undefined']}",
        priority="high"
    )
```

### Example 2: Optimize Slow Notebook

```python
# Find slowest cells
slow = get_slowest_cells(top=5)

for cell in slow["slowest_cells"]:
    # Profile the cell
    profile = profile_cell(index=cell["index"])
    
    # Annotate with optimization notes
    annotate_cell(
        index=cell["index"],
        note=f"Takes {cell['execution_time_human']}, bottleneck: {profile['profile_results'][0]['function']}",
        type="warning"
    )
```

### Example 3: Validate Notebook Before Commit

```python
# Validate notebook
validation = validate_notebook()

if not validation["valid"]:
    print(f"Found {validation['total_issues']} issues:")
    for issue in validation["issues"]:
        print(f"  - Cell {issue['cell_index']}: {issue['message']}")
    
    # Check reproducibility
    repro = check_reproducibility()
    if not repro["reproducible"]:
        print("Notebook is not reproducible!")
```

### Example 4: Refactor Repeated Code

```python
# Find cells with similar patterns
cells = find_cells(pattern="df.groupby.*sum")

# Extract to function
extract_to_function(
    index=cells["matches"][0]["index"],
    func_name="aggregate_by_group",
    params=["df", "group_col", "value_col"]
)

# Update other cells to use the function
for cell in cells["matches"][1:]:
    edit_cell_source(
        index=cell["index"],
        find=cell["source"],
        replace="result = aggregate_by_group(df, 'category', 'revenue')"
    )
```

### Example 5: Section-based Execution

```python
# List all sections
sections = list_sections()

# Execute only specific sections
for section in ["Data Loading", "Feature Engineering"]:
    result = execute_section(section=section)
    print(f"Executed {section}: {result['total_executed']} cells in {result['total_time_ms']}ms")
```

---

## Best Practices

1. **Use find_cells** before batch operations to target specific cells
2. **Check dependencies** with get_cell_dependencies before refactoring
3. **Validate notebooks** regularly with validate_notebook
4. **Profile slow cells** to identify optimization opportunities
5. **Save baselines** for regression testing outputs
6. **Annotate complex cells** for future reference
7. **Use sections** to organize large notebooks
8. **Extract functions** for repeated code patterns
9. **Check reproducibility** before sharing notebooks
10. **Monitor memory** with get_cell_memory_usage for large datasets
