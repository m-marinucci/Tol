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
    if [ -f "performance-results.txt" ]; then
        cp performance-results.txt "$RELEASE_DIR/"
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

# Create installation scripts
create_installation_scripts() {
    log_step "Creating installation scripts"
    
    # Linux installation script
    cat > "$RELEASE_DIR/install-linux.sh" << 'EOF'
#!/bin/bash
# TOL Linux Installation Script

set -e

INSTALL_PREFIX="${1:-/usr/local}"
PACKAGE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing TOL to $INSTALL_PREFIX"

# Find the Linux package
LINUX_PACKAGE=$(find "$PACKAGE_DIR" -name "tol-linux-*.tar.gz" | head -1)

if [ -z "$LINUX_PACKAGE" ]; then
    echo "Error: No Linux package found"
    exit 1
fi

echo "Using package: $(basename "$LINUX_PACKAGE")"

# Extract and install
TEMP_DIR=$(mktemp -d)
tar -xzf "$LINUX_PACKAGE" -C "$TEMP_DIR"

EXTRACTED_DIR=$(find "$TEMP_DIR" -name "tol-linux-*" -type d | head -1)

if [ -d "$EXTRACTED_DIR/bin" ]; then
    sudo cp -r "$EXTRACTED_DIR/bin"/* "$INSTALL_PREFIX/bin/"
    echo "Binaries installed to $INSTALL_PREFIX/bin/"
fi

if [ -d "$EXTRACTED_DIR/lib" ]; then
    sudo cp -r "$EXTRACTED_DIR/lib"/* "$INSTALL_PREFIX/lib/"
    echo "Libraries installed to $INSTALL_PREFIX/lib/"
fi

# Update library cache
sudo ldconfig

# Cleanup
rm -rf "$TEMP_DIR"

echo "TOL installation completed successfully!"
echo "Run 'tolcon --version' to verify installation"
EOF

    chmod +x "$RELEASE_DIR/install-linux.sh"
    
    # Windows installation script
    cat > "$RELEASE_DIR/install-windows.bat" << 'EOF'
@echo off
REM TOL Windows Installation Script

echo Installing TOL for Windows...

REM Find Windows package
for %%f in (tol-windows-*.zip) do set WINDOWS_PACKAGE=%%f

if "%WINDOWS_PACKAGE%"=="" (
    echo Error: No Windows package found
    exit /b 1
)

echo Using package: %WINDOWS_PACKAGE%

REM Extract package (requires PowerShell)
powershell -command "Expand-Archive -Path '%WINDOWS_PACKAGE%' -DestinationPath '.' -Force"

REM Find extracted directory
for /d %%d in (tol-windows-*) do set EXTRACTED_DIR=%%d

if "%EXTRACTED_DIR%"=="" (
    echo Error: Could not find extracted directory
    exit /b 1
)

echo Extracted to: %EXTRACTED_DIR%

REM Copy to Program Files (requires admin)
set INSTALL_DIR=%ProgramFiles%\TOL

if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"

xcopy "%EXTRACTED_DIR%\*" "%INSTALL_DIR%\" /E /I /Y

REM Add to PATH (requires admin)
setx PATH "%PATH%;%INSTALL_DIR%\bin" /M

echo TOL installation completed successfully!
echo Run 'tolcon --version' to verify installation
echo Note: You may need to restart your command prompt
EOF

    log_info "Installation scripts created"
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
    echo "Installation scripts:" >> "$manifest"
    find . -name "install-*" | sort >> "$manifest"
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
    create_installation_scripts
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
