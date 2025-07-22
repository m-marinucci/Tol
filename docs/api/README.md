# TOL API Documentation

This directory contains comprehensive API documentation for all TOL modules.
Last updated: 2025-07-20 22:44:28 UTC

## Quick Overview

- **Total Modules**: 12
- **MCP Compatible**: 8
- **Categories**: 6

## Table of Contents

- [Core Computational Modules](#core-computational)
- [Data Handling and I/O](#data-handling)
- [Visualization and Plotting](#visualization)
- [User Interface](#ui)
- [Integration Modules](#integration)
- [Utilities and Standard Library](#utilities)
- [Alphabetical Index](#alphabetical-index)
- [MCP-Compatible Modules](#mcp-compatible-modules)

## Core Computational Modules

Mathematical operations, statistical analysis, and time-series processing

### [bmath](mathematical_operations.md) 🤖
- **Version**: 1.0.0
- **Last Updated**: 2025-06-14
- **Tags**: `mathematics`, `linear-algebra`, `numerical-computation`, `performance-critical`

### [bstat](statistical_analysis.md) 🤖
- **Version**: 1.0.0
- **Last Updated**: 2025-06-14
- **Tags**: `statistics`, `time-series-modeling`, `machine-learning`, `econometrics`, `clustering`

### [btol_core](core_data_types.md) 🤖
- **Version**: 1.0.0
- **Last Updated**: 2025-06-14
- **Tags**: `data-types`, `core-functionality`, `matrix-operations`, `text-processing`

### [btol_time_series](time_series_analysis.md) 🤖
- **Version**: 1.0.0
- **Last Updated**: 2025-06-14
- **Tags**: `time-series`, `temporal-data`, `financial-analysis`, `econometrics`, `data-manipulation`

## Data Handling and I/O

Database connectivity and file system operations

### [dbdrivers](database_connectivity.md) 🤖
- **Version**: 1.0.0
- **Last Updated**: 2025-06-14
- **Tags**: `database`, `sql`, `data-import`, `connectivity`, `odbc`, `mysql`, `postgresql`, `sqlite`

### [system_io](file_system_integration.md) 🤖
- **Version**: 1.0.0
- **Last Updated**: 2025-06-14
- **Tags**: `file-io`, `system-integration`, `data-export`, `utilities`, `networking`, `archives`

## Visualization and Plotting

Chart generation and data visualization tools

### [plotter](plotting_functions.md) 🤖
- **Version**: 1.0.0
- **Last Updated**: 2025-06-14
- **Tags**: `plotting`, `visualization`, `charts`, `graphics`, `data-visualization`

### [tolbase_viz](gui_visualization.md)
- **Version**: 1.0.0
- **Last Updated**: 2025-06-14
- **Tags**: `gui`, `interactive-plots`, `visualization`, `tcl-tk`, `blt`

## User Interface

GUI applications and interactive tools

### [tolbase](gui_application.md)
- **Version**: 1.0.0
- **Last Updated**: 2025-06-14
- **Tags**: `gui`, `ide`, `interactive`, `development-environment`, `tcl-tk`

## Integration Modules

External language bindings and communication protocols

### [tolcomm](communication_remote.md)
- **Version**: 1.0.0
- **Last Updated**: 2025-06-14
- **Tags**: `networking`, `remote-execution`, `client-server`, `distributed`, `communication`

### [toljava](java_api.md)
- **Version**: 1.0.0
- **Last Updated**: 2025-06-14
- **Tags**: `java`, `jni`, `integration`, `embedding`, `cross-platform`

## Utilities and Standard Library

Helper functions and standard library modules

### [stdlib](standard_library.md) 🤖
- **Version**: 1.0.0
- **Last Updated**: 2025-06-14
- **Tags**: `standard-library`, `utilities`, `configuration`, `text-processing`, `random-generation`

## Alphabetical Index

- **[bmath](mathematical_operations.md)** 🤖 - Core Computational Modules
- **[bstat](statistical_analysis.md)** 🤖 - Core Computational Modules
- **[btol_core](core_data_types.md)** 🤖 - Core Computational Modules
- **[btol_time_series](time_series_analysis.md)** 🤖 - Core Computational Modules
- **[dbdrivers](database_connectivity.md)** 🤖 - Data Handling and I/O
- **[plotter](plotting_functions.md)** 🤖 - Visualization and Plotting
- **[stdlib](standard_library.md)** 🤖 - Utilities and Standard Library
- **[system_io](file_system_integration.md)** 🤖 - Data Handling and I/O
- **[tolbase](gui_application.md)** - User Interface
- **[tolbase_viz](gui_visualization.md)** - Visualization and Plotting
- **[tolcomm](communication_remote.md)** - Integration Modules
- **[toljava](java_api.md)** - Integration Modules

## MCP-Compatible Modules

These modules are available through the TOL MCP (Model Context Protocol) server 
for natural language interaction:

- **[bmath](mathematical_operations.md)** 🤖
- **[bstat](statistical_analysis.md)** 🤖
- **[btol_core](core_data_types.md)** 🤖
- **[btol_time_series](time_series_analysis.md)** 🤖
- **[dbdrivers](database_connectivity.md)** 🤖
- **[plotter](plotting_functions.md)** 🤖
- **[stdlib](standard_library.md)** 🤖
- **[system_io](file_system_integration.md)** 🤖

---

## Contributing

When adding new API documentation:
1. Follow the [YAML front-matter template](../yaml_frontmatter_template.yaml)
2. Use consistent markdown formatting
3. Run `python scripts/generate_api_index.py` to update this index
4. Validate with `markdownlint docs/api/*.md`

For detailed guidelines, see [CONTRIBUTOR_GUIDELINES.md](../CONTRIBUTOR_GUIDELINES.md)
