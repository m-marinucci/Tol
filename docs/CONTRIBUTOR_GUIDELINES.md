# TOL API Documentation Contributor Guidelines

This document provides clear instructions for contributors working on TOL API documentation, including the merge strategy for PR #14 and PR #15, and ongoing documentation standards.

## Overview

The TOL API documentation follows a unified structure that combines:

- **PR #14's approach**: User-friendly filenames and comprehensive organization
- **PR #15's approach**: Detailed technical content and accurate module references
- **YAML front-matter**: Machine-readable metadata for MCP server integration

## Merge Options

### Option A: Sequential Merge (Recommended)

**Step 1: Merge PR #14 First**

1. PR #14 establishes the base structure in `docs/api/`
2. Creates the main README.md index
3. Sets the filename convention

**Step 2: Rebase and Update PR #15**

1. PR #15 author rebases onto merged PR #14
2. Moves files from `docs/api_reference/` to `docs/api/`
3. Renames files according to mapping table (see below)
4. Adds YAML front-matter to all files
5. Merges content where files overlap

### Option B: Consolidated Merge

Create a new branch that manually combines both PRs:

1. Clone repository and create `docs-consolidation` branch
2. Manually merge content from both PRs
3. Apply file naming mappings
4. Add YAML front-matter
5. Submit as new PR

## File Naming Mappings

| PR #14 Filename | PR #15 Filename | Final Filename | Module ID |
|-----------------|-----------------|----------------|-----------|
| mathematical_operations.md | bmath.md | mathematical_operations.md | bmath |
| statistical_analysis.md | bstat.md | statistical_analysis.md | bstat |
| time_series_analysis.md | btol_time_series.md | time_series_analysis.md | btol_time_series |
| core_data_types.md | btol_core_data_types.md | core_data_types.md | btol_core |
| database_connectivity.md | dbdrivers.md | database_connectivity.md | dbdrivers |
| file_system_integration.md | system_io.md | file_system_integration.md | system_io |
| plotting_functions.md | plotter.md | plotting_functions.md | plotter |
| gui_application.md | gui_application.md | gui_application.md | tolbase |
| gui_visualization.md | gui_visualization.md | gui_visualization.md | tolbase_viz |
| java_api.md | toljava.md | java_api.md | toljava |
| communication_remote.md | tolcomm.md | communication_remote.md | tolcomm |
| standard_library.md | stdlib.md | standard_library.md | stdlib |

## Required YAML Front-matter Format

Every documentation file must include YAML front-matter at the top:

```yaml
---
module_id: "bmath"                    # Required: Internal module identifier
category: "core_computational"        # Required: One of the 6 categories
version: "1.0.0"                     # Required: Semantic version
last_updated: "2025-06-14"           # Required: YYYY-MM-DD format
dependencies:                        # Optional: List of required modules
  - "bbasic"
  - "gsl"
mcp_compatible: true                 # Required: Boolean for MCP server
tags:                               # Optional: Keywords for search
  - "mathematics"
  - "linear-algebra"
---
```

### Category Assignments

Use exactly these category values:

- **core_computational**: bmath, bstat, btol_time_series, btol_core
- **data_handling**: dbdrivers, system_io
- **visualization**: plotter, tolbase_viz
- **ui**: tolbase
- **integration**: toljava, tolcomm
- **utilities**: stdlib

## Content Structure Template

Each documentation file should follow this structure:

```markdown
---
[YAML front-matter here]
---

# Module Name (module_id)

## Module Overview
[Comprehensive description of module purpose and capabilities]

## Core Functions/Classes

### FunctionName(parameters)
[Detailed function documentation]

**Parameters**
- `param` (`Type`): description

**Returns**
- `Type`: description

**Example**
```tol
[Working TOL code example]
```

**Errors**

- `ErrorType` if condition

## Data Types

[List and describe relevant data types]

## Integration Notes

[How this module works with other modules]

## Performance Considerations

[Memory usage, computational complexity, optimization tips]

## Related Modules

[Cross-references to related documentation]

```

## Step-by-Step Update Instructions

### For PR #15 Author (Sequential Merge)

1. **Wait for PR #14 to be merged**

2. **Rebase your branch**:
   ```bash
   git checkout utft2s-codex/create-api-documentation-for-tol-modules
   git rebase master
   ```

3. **Move and rename files**:

   ```bash
   # Create the target directory structure
   mkdir -p docs/api
   
   # Move and rename each file according to mapping table
   mv docs/api_reference/bmath.md docs/api/mathematical_operations.md
   mv docs/api_reference/bstat.md docs/api/statistical_analysis.md
   # ... continue for all files
   
   # Remove old directory
   rmdir docs/api_reference
   ```

4. **Add YAML front-matter to each file**:
   - Use the template from `docs/yaml_frontmatter_template.yaml`
   - Ensure all required fields are present
   - Validate category assignments

5. **Merge content where files overlap**:
   - Keep PR #15's detailed content structure
   - Preserve any unique examples from PR #14
   - Maintain consistent formatting

6. **Validate and test**:

   ```bash
   # Validate YAML front-matter
   python scripts/generate_api_index.py --validate-only
   
   # Generate updated README
   python scripts/generate_api_index.py
   
   # Lint markdown files
   npx markdownlint docs/api/*.md --fix
   ```

7. **Update commit message and push**:

   ```bash
   git add docs/api/
   git commit -m "Merge API documentation: combine PR #14 structure with PR #15 content
   
   - Move files to docs/api/ directory
   - Add YAML front-matter to all files
   - Merge content from both PRs
   - Generate updated README index"
   
   git push origin utft2s-codex/create-api-documentation-for-tol-modules
   ```

### For New Contributors

1. **Choose appropriate filename** from the established convention
2. **Use the YAML template** from `docs/yaml_frontmatter_template.yaml`
3. **Follow the content structure** outlined above
4. **Test your documentation**:

   ```bash
   python scripts/generate_api_index.py --validate-only
   ```

5. **Update the index**:

   ```bash
   python scripts/generate_api_index.py
   ```

## Quality Checklist

Before submitting documentation:

- [ ] YAML front-matter includes all required fields
- [ ] Module ID matches actual codebase module name
- [ ] Category is one of the 6 approved categories
- [ ] Version follows semantic versioning (X.Y.Z)
- [ ] Date is in YYYY-MM-DD format
- [ ] Examples are tested and working
- [ ] Error conditions are documented
- [ ] Parameter types are specified
- [ ] Return values are documented
- [ ] Cross-references to related modules are included
- [ ] MCP compatibility is correctly specified
- [ ] Markdown formatting is consistent
- [ ] File passes markdownlint validation

Before running the helper scripts below, make sure the required Python
packages are installed:

```bash
pip install -r requirements.txt
```

This installs dependencies like **PyYAML** used by the index generator.

## Automated Tools

### Index Generation

```bash
# Generate/update the main README
python scripts/generate_api_index.py

# Validate only (don't generate)
python scripts/generate_api_index.py --validate-only
```

### Markdown Linting

```bash
# Fix common markdown issues
npx markdownlint docs/api/*.md --fix

# Check for issues without fixing
npx markdownlint docs/api/*.md
```

### YAML Validation

The index generator automatically validates YAML front-matter and reports errors.

## Benefits for User Personas

This documentation structure serves multiple audiences:

- **Novice TOL Users**: Clear filenames, comprehensive examples, step-by-step guidance
- **Experienced Developers**: Detailed API specifications, error handling, performance notes
- **Statisticians**: Well-documented mathematical functions with practical examples
- **System Integrators**: Complete module specifications with dependency information
- **MCP Development**: Machine-readable metadata for natural language interface

## Support and Questions

For questions about the documentation process:

1. Check this guide first
2. Review existing documentation examples
3. Validate with automated tools
4. Create an issue for clarification if needed

## Future Enhancements

Planned improvements to the documentation system:

- Interactive code examples
- Automated API extraction from C++ source
- Documentation versioning
- Integration with TOL playground
- Enhanced MCP metadata
