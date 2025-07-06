#!/bin/bash
# Release automation script for TOL project
# Creates release packages and artifacts

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
RELEASE_DIR="${PROJECT_ROOT}/release"
VERSION="${1:-$(date +%Y.%m.%d)}"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

# Create release directory
mkdir -p "$RELEASE_DIR"

log_info "Creating TOL release v$VERSION"
log_info "Release directory: $RELEASE_DIR"

# Package Linux builds
package_linux_builds() {
    log_step "Packaging Linux builds"
    
    for artifact_dir in tol-linux-*; do
        if [ -d "$artifact_dir" ]; then
            local package_name="${artifact_dir}-v${VERSION}.tar.gz"
            log_info "Creating package: $package_name"
            
            tar -czf "$RELEASE_DIR/$package_name" "$artifact_dir"
            
            # Create checksum
            cd "$RELEASE_DIR"
            sha256sum "$package_name" > "${package_name}.sha256"
            cd - > /dev/null
        fi
    done
}

# Package Windows builds
package_windows_builds() {
    log_step "Packaging Windows builds"
    
    for artifact_dir in tol-windows-*; do
        if [ -d "$artifact_dir" ]; then
            local package_name="${artifact_dir}-v${VERSION}.zip"
            log_info "Creating package: $package_name"
            
            zip -r "$RELEASE_DIR/$package_name" "$artifact_dir"
            
            # Create checksum
            cd "$RELEASE_DIR"
            sha256sum "$package_name" > "${package_name}.sha256"
            cd - > /dev/null
        fi
    done
}

# Create source package
create_source_package() {
    log_step "Creating source package"
    
    local source_package="tol-source-v${VERSION}.tar.gz"
    log_info "Creating source package: $source_package"
    
    # Create temporary directory for clean source
    local temp_dir=$(mktemp -d)
    local source_dir="$temp_dir/tol-$VERSION"
    
    # Copy source files (excluding build artifacts)
    mkdir -p "$source_dir"
    rsync -av \
        --exclude='build/' \
        --exclude='CMakeFiles/' \
        --exclude='CMakeCache.txt' \
        --exclude='coverage_html/' \
        --exclude='.DS_Store' \
        --exclude='*.o' \
        --exclude='*.so' \
        --exclude='*.a' \
        --exclude='*.exe' \
        --exclude='*.dll' \
        --exclude='.git/' \
        --exclude='autom4te.cache/' \
        "$PROJECT_ROOT/" "$source_dir/"
    
    # Create tarball
    cd "$temp_dir"
    tar -czf "$RELEASE_DIR/$source_package" "tol-$VERSION"
    cd - > /dev/null
    
    # Create checksum
    cd "$RELEASE_DIR"
    sha256sum "$source_package" > "${source_package}.sha256"
    cd - > /dev/null
    
    # Cleanup
    rm -rf "$temp_dir"
}

# Create documentation package
create_documentation_package() {
    log_step "Creating documentation package"
    
    if [ -d "$PROJECT_ROOT/docs" ]; then
        local docs_package="tol-documentation-v${VERSION}.tar.gz"
        log_info "Creating documentation package: $docs_package"
        
        cd "$PROJECT_ROOT"
        tar -czf "$RELEASE_DIR/$docs_package" docs/
        cd - > /dev/null
        
        # Create checksum
        cd "$RELEASE_DIR"
        sha256sum "$docs_package" > "${docs_package}.sha256"
        cd - > /dev/null
    else
        log_info "No documentation directory found, skipping documentation package"
    fi
}

# Include test reports
include_test_reports() {
    log_step "Including test and analysis reports"
    
    # Copy static analysis reports
    if [ -d "static-analysis-report" ]; then
        cp -r static-analysis-report "$RELEASE_DIR/"
        log_info "Included static analysis report"
    fi
    
    # Copy performance results
    if [ -f "performance-results.json" ]; then
        cp performance-results.json "$RELEASE_DIR/"
        log_info "Included performance results"
    fi
    
    # Copy coverage reports
    if [ -d "coverage_html" ]; then
        tar -czf "$RELEASE_DIR/coverage-report-v${VERSION}.tar.gz" coverage_html/
        log_info "Included coverage report"
    fi
}

# Create release notes
create_release_notes() {
    log_step "Creating release notes"
    
    local release_notes="$RELEASE_DIR/RELEASE_NOTES.md"
    
    cat > "$release_notes" << EOF
# TOL Release v$VERSION

Release Date: $(date +"%Y-%m-%d")

## Overview

This release includes the complete TOL (Time Oriented Language) distribution with cross-platform support for Linux and Windows.

## What's Included

### Binary Packages
- Linux builds for multiple GCC versions (9, 10, 11, 12)
- Windows build with MSVC
- All packages include runtime libraries and dependencies

### Source Code
- Complete source code with build instructions
- CMake build system with testing integration
- Cross-platform compatibility improvements

### Documentation
- Complete API reference (Doxygen-generated)
- User manual with examples
- Installation and build instructions

### Quality Assurance
- Static analysis reports
- Performance benchmarks
- Test coverage reports
- Memory leak analysis

## Installation

### Linux
\`\`\`bash
# Extract the appropriate package for your system
tar -xzf tol-linux-gcc-11-v$VERSION.tar.gz
cd tol-linux-gcc-11

# Install to system
sudo cp -r bin/* /usr/local/bin/
sudo cp -r lib/* /usr/local/lib/
\`\`\`

### Windows
\`\`\`cmd
# Extract the Windows package
# Run the installer or copy files to desired location
\`\`\`

## System Requirements

### Linux
- GCC 9.0 or later
- CMake 3.0 or later
- GSL (GNU Scientific Library)
- FFTW3
- LAPACK/BLAS

### Windows
- Visual Studio 2019 or later
- CMake 3.0 or later
- vcpkg for dependencies

## Verification

All packages include SHA256 checksums for verification:
\`\`\`bash
sha256sum -c package-name.sha256
\`\`\`

## Support

For issues and support:
- GitHub Issues: https://github.com/m-marinucci/Tol/issues
- Documentation: https://m-marinucci.github.io/Tol/

## Changes in This Release

- Enhanced Linux compatibility
- Improved build system reliability
- Comprehensive testing framework
- Automated CI/CD pipeline
- Performance optimizations
- Memory leak fixes
- Updated documentation

---

Generated on $(date) by TOL Release Automation
EOF

    log_info "Release notes created: $release_notes"
}

# Generate manifest
generate_manifest() {
    log_step "Generating release manifest"
    
    local manifest="$RELEASE_DIR/MANIFEST.txt"
    
    cat > "$manifest" << EOF
TOL Release v$VERSION Manifest
Generated on: $(date)

Files in this release:
EOF

    cd "$RELEASE_DIR"
    find . -type f -name "*.tar.gz" -o -name "*.zip" -o -name "*.sha256" | sort >> "$manifest"
    echo "" >> "$manifest"
    echo "Documentation:" >> "$manifest"
    find . -name "*.md" -o -name "*.txt" | grep -v MANIFEST | sort >> "$manifest"
    cd - > /dev/null
    
    log_info "Manifest generated: $manifest"
}

# Main execution
main() {
    log_info "TOL Release Creation v$VERSION"
    log_info "================================"
    
    # Package builds
    package_linux_builds
    package_windows_builds
    
    # Create additional packages
    create_source_package
    create_documentation_package
    
    # Include reports
    include_test_reports
    
    # Create release materials
    create_release_notes
    generate_manifest
    
    log_info "Release creation completed!"
    log_info "Release directory: $RELEASE_DIR"
    
    # Show summary
    echo ""
    log_info "Release Summary:"
    cd "$RELEASE_DIR"
    ls -la *.tar.gz *.zip 2>/dev/null || true
    cd - > /dev/null
    
    echo ""
    log_info "Total release size:"
    du -sh "$RELEASE_DIR"
}

# Run main function
main "$@"
