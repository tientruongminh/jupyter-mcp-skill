# CHANGELOG.md

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-06-12

### Added

#### Core Features (20 tools)
- File & kernel management (`list_files`, `list_kernels`, `connect_to_jupyter`)
- Notebook lifecycle (`use_notebook`, `list_notebooks`, `restart_notebook`, `unuse_notebook`, `read_notebook`)
- Cell operations (`read_cell`, `insert_cell`, `delete_cell`, `move_cell`, `overwrite_cell_source`, `edit_cell_source`)
- Cell execution (`execute_cell`, `insert_execute_code_cell`, `execute_code`)
- JupyterLab integration (`notebook_run-all-cells`, `notebook_get-selected-cell`)
- Prompts (`jupyter-cite`)

#### Advanced Features (40+ tools)
- **Cell History & Tracking**: `diff_cell`, `rollback_cell`
- **Smart Search**: `find_cells`, `get_cell_dependencies`, `get_affected_cells`
- **Batch Operations**: `execute_cells`, `batch_edit_cells`
- **Output Filtering**: `get_cell_output`, `get_dataframe_output`
- **Annotations**: `annotate_cell`, `get_cell_annotations`, `flag_cell`, `list_flagged_cells`
- **Execution Analytics**: `get_cell_execution_time`, `get_slowest_cells`, `get_cell_memory_usage`
- **Smart Insertion**: `insert_cell_after_imports`, `insert_cell_before_plots`, `insert_cleanup_cell`
- **Cell Templates**: `insert_dataframe_inspect_cell`, `insert_plot_cell`, `insert_error_handling_cell`
- **Kernel Inspection**: `list_kernel_variables`, `get_variable_info`, `get_variable_value`, `check_cell_variables`
- **Validation**: `validate_notebook`, `check_reproducibility`, `compare_cell_outputs`, `save_cell_output_baseline`, `compare_with_baseline`
- **Magic Commands**: `timeit_cell`, `profile_cell`, `debug_cell`
- **Refactoring**: `extract_to_function`, `merge_cells`, `split_cell`
- **Section Management**: `list_sections`, `get_section_cells`, `execute_section`, `insert_section_header`

#### Documentation
- Complete SKILL.md with setup, usage, and best practices
- Tools reference (tools.md) with all 20 basic tools
- Advanced features reference (advanced-features.md) with 40+ extended tools
- 10 usage examples (examples.md) covering Cursor, Codex, Claude Desktop
- Quick start README
- Connection test script

#### Infrastructure
- MIT License
- .gitignore for Python/Jupyter
- Git repository initialization
- GitHub repository created

### Security
- Token protection guidelines
- Arbitrary code execution warnings
- User consent requirements documented

### Developer Experience
- Connection test script (`scripts/test-connection.sh`)
- Auto-detection of uv installation
- Environment variable validation
- Clear error messages

## [Unreleased]

### Planned
- ClawHub publication
- Video/GIF demos
- Integration tests
- CI/CD pipeline
- Notebook templates
- VS Code snippets

---

[1.0.0]: https://github.com/tientruongminh/jupyter-mcp-skill/releases/tag/v1.0.0
