# TOL Documentation

This directory contains the documentation for the TOL (Time Oriented Language) project.

## Documentation Structure

```
docs/
├── README.md           # This file
├── index.md           # Main documentation homepage
├── getting-started/   # Installation and setup guides
├── language/          # TOL language reference
├── api/              # API documentation
├── developer/        # Developer guides
├── changelog/        # Auto-generated changelogs
├── doxygen/         # Doxygen-generated API docs
└── public/          # Built documentation site
```

## Automatic Documentation Generation

Documentation is automatically generated and updated on every commit to the master branch using GitHub Actions.

### What Gets Auto-Generated

1. **API Documentation** - Extracted from C++ source code comments using Doxygen
2. **Language Reference** - Generated from TOL test files and examples
3. **Changelog** - Created from Git commit history
4. **Metrics** - Documentation coverage statistics

### Documentation Workflow

1. **On Every Push**:
   - Analyzes changed files
   - Regenerates affected documentation sections
   - Updates metrics and timestamps

2. **On Pull Requests**:
   - Builds documentation preview
   - Comments build status
   - Checks documentation coverage

3. **On Master Branch**:
   - Deploys to GitHub Pages
   - Updates live documentation site

## Local Documentation Build

To build documentation locally:

```bash
# Install dependencies
pip install mkdocs mkdocs-material mkdocs-mermaid2-plugin
sudo apt-get install doxygen graphviz

# Build documentation
mkdocs build

# Serve locally
mkdocs serve
```

## Writing Documentation

### For C++ Code

Use Doxygen-style comments:

```cpp
/**
 * @brief Calculate the square of a number
 * @param x The input value
 * @return The square of x
 */
Real Square(Real x) {
    return x * x;
}
```

### For TOL Code

Use structured comments:

```tol
//! @brief Time series analysis function
//! @param data Input time series
//! @return Analyzed results
Real AnalyzeSeries(Serie data) {
    // Implementation
}
```

## Documentation Standards

1. **Always Document**:
   - Public APIs
   - Complex algorithms
   - Non-obvious behavior
   - Configuration options

2. **Include Examples**:
   - Code snippets
   - Use cases
   - Common patterns

3. **Keep Updated**:
   - Update docs with code changes
   - Review auto-generated content
   - Fix broken links

## Maintenance

The documentation system requires minimal maintenance:

- **Automatic updates** via GitHub Actions
- **Version tracking** through Git
- **Quality checks** in CI/CD pipeline

For issues or improvements, please open an issue or PR.