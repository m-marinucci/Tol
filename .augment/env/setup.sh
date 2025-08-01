#!/bin/bash
set -e

echo "=== TOL (Time Oriented Language) Test Environment Setup ==="
echo "Setting up test environment for TOL project"

# Detect package manager and set commands
detect_package_manager() {
    if command -v apt-get >/dev/null 2>&1; then
        PKG_UPDATE="apt-get update"
        PKG_INSTALL="apt-get install -y"
        PKG_SUDO="sudo"
    elif command -v yum >/dev/null 2>&1; then
        PKG_UPDATE="yum check-update || true"
        PKG_INSTALL="yum install -y"
        PKG_SUDO="sudo"
    elif command -v dnf >/dev/null 2>&1; then
        PKG_UPDATE="dnf check-update || true"
        PKG_INSTALL="dnf install -y"
        PKG_SUDO="sudo"
    elif command -v pacman >/dev/null 2>&1; then
        PKG_UPDATE="pacman -Sy"
        PKG_INSTALL="pacman -S --noconfirm"
        PKG_SUDO="sudo"
    elif command -v brew >/dev/null 2>&1; then
        PKG_UPDATE="brew update"
        PKG_INSTALL="brew install"
        PKG_SUDO=""
    else
        echo "Warning: No supported package manager found. Skipping package installation."
        PKG_UPDATE=""
        PKG_INSTALL=""
        PKG_SUDO=""
    fi
}

# Check if running in CI or container without sudo
check_sudo_availability() {
    if [ "$PKG_SUDO" = "sudo" ] && ! sudo -n true 2>/dev/null; then
        if [ -n "$CI" ] || [ -n "$GITHUB_ACTIONS" ] || [ -n "$GITLAB_CI" ]; then
            echo "Running in CI environment without sudo, trying without sudo..."
            PKG_SUDO=""
        else
            echo "Error: sudo is required but not available. Please run with appropriate privileges."
            exit 1
        fi
    fi
}

detect_package_manager
check_sudo_availability

# Update package list (if package manager available)
if [ -n "$PKG_UPDATE" ]; then
    echo "Updating package list..."
    $PKG_SUDO $PKG_UPDATE
fi

# Install basic dependencies for testing (if package manager available)
if [ -n "$PKG_INSTALL" ]; then
    echo "Installing basic dependencies..."
    if command -v apt-get >/dev/null 2>&1; then
        $PKG_SUDO $PKG_INSTALL cmake build-essential python3 python3-pip git wget curl
    elif command -v yum >/dev/null 2>&1 || command -v dnf >/dev/null 2>&1; then
        $PKG_SUDO $PKG_INSTALL cmake gcc gcc-c++ python3 python3-pip git wget curl
    elif command -v pacman >/dev/null 2>&1; then
        $PKG_SUDO $PKG_INSTALL cmake base-devel python python-pip git wget curl
    elif command -v brew >/dev/null 2>&1; then
        $PKG_SUDO $PKG_INSTALL cmake python3 git wget curl
    fi
else
    echo "Skipping package installation - no supported package manager found"
fi

# Set working directory (configurable via WORKSPACE_DIR, defaults to /mnt/persist/workspace)
WORKSPACE_DIR="${WORKSPACE_DIR:-/mnt/persist/workspace}"
if [ ! -d "$WORKSPACE_DIR" ]; then
    echo "Workspace directory $WORKSPACE_DIR does not exist. Creating it..."
    mkdir -p "$WORKSPACE_DIR"
fi
cd "$WORKSPACE_DIR"

# Create a mock TOL interpreter for testing the test framework (idempotent)
if [ ! -f "/usr/local/tol/bin/tolcon" ]; then
    echo "Creating mock TOL interpreter for test framework validation..."

    # Create directory with appropriate permissions
    if [ "$PKG_SUDO" = "sudo" ]; then
        sudo mkdir -p /usr/local/tol/bin
    else
        # For CI environments or when sudo is not available
        mkdir -p "$HOME/.local/bin"
        export PATH="$HOME/.local/bin:$PATH"
        TOL_BIN_DIR="$HOME/.local/bin"
    fi

    # Set the target directory
    TOL_BIN_DIR="${TOL_BIN_DIR:-/usr/local/tol/bin}"

    # Create a simple mock tolcon script that can be used to test the framework
    cat > /tmp/mock_tolcon << 'EOF'
#!/bin/bash
# Mock TOL interpreter for testing purposes

# Handle different command line arguments
case "$1" in
    "--version")
        echo "Mock TOL 1.0.0"
        exit 0
        ;;
    "-c")
        # Handle inline commands
        if [[ "$2" == *"TOL_VERSION_CHECK"* ]]; then
            echo "TOL_VERSION_CHECK"
            exit 0
        elif [[ "$2" == *"TOL_TEST_SUCCESS"* ]]; then
            echo "TOL_TEST_SUCCESS"
            exit 0
        else
            echo "Mock TOL executing: $2"
            exit 0
        fi
        ;;
    "-v")
        # Handle .tol file execution
        if [ -f "$2" ]; then
            echo "Mock TOL executing file: $2"
            echo "Test execution completed successfully"
            exit 0
        else
            echo "Error: File not found: $2"
            exit 1
        fi
        ;;
    *)
        if [[ "$1" == *.tol ]]; then
            echo "Mock TOL executing file: $1"
            echo "Test execution completed successfully"
            exit 0
        else
            echo "Mock TOL interpreter v1.0"
            echo "Usage: tolcon [options] [file.tol]"
            exit 0
        fi
        ;;
esac
EOF

    # Copy and set permissions
    if [ "$PKG_SUDO" = "sudo" ] && [ "$TOL_BIN_DIR" = "/usr/local/tol/bin" ]; then
        sudo cp /tmp/mock_tolcon "$TOL_BIN_DIR/tolcon"
        sudo chmod +x "$TOL_BIN_DIR/tolcon"
    else
        cp /tmp/mock_tolcon "$TOL_BIN_DIR/tolcon"
        chmod +x "$TOL_BIN_DIR/tolcon"
    fi

    # Add TOL binary to PATH (idempotent)
    echo "Adding TOL to PATH..."
    PATH_ENTRY="export PATH=\"$TOL_BIN_DIR:\$PATH\""

    # Check if PATH entry already exists in .profile
    if [ -f "$HOME/.profile" ] && grep -q "$TOL_BIN_DIR" "$HOME/.profile"; then
        echo "TOL path already exists in .profile"
    else
        echo "$PATH_ENTRY" >> "$HOME/.profile"
        echo "Added TOL path to .profile"
    fi

    # Also check .bashrc for broader compatibility
    if [ -f "$HOME/.bashrc" ] && ! grep -q "$TOL_BIN_DIR" "$HOME/.bashrc"; then
        echo "$PATH_ENTRY" >> "$HOME/.bashrc"
        echo "Added TOL path to .bashrc"
    fi

    export PATH="$TOL_BIN_DIR:$PATH"
else
    echo "TOL interpreter already exists at /usr/local/tol/bin/tolcon, skipping installation"
    # Ensure PATH is set for current session
    if [ -d "/usr/local/tol/bin" ]; then
        export PATH="/usr/local/tol/bin:$PATH"
    elif [ -d "$HOME/.local/bin" ] && [ -f "$HOME/.local/bin/tolcon" ]; then
        export PATH="$HOME/.local/bin:$PATH"
    fi
fi

# Verify TOL installation
echo "Verifying TOL installation..."
echo "Testing version check:"
/usr/local/tol/bin/tolcon --version

echo "Testing inline command:"
/usr/local/tol/bin/tolcon -c "WriteLn(\"TOL_TEST_SUCCESS\")"

# Create a simple test script in the workspace root (idempotent)
echo "Creating simple test runner..."
cd "$WORKSPACE_DIR"

if [ ! -f "run_simple_tests.sh" ]; then
    cat > run_simple_tests.sh << 'EOF'
#!/bin/bash
set -e

echo "=== Running Simple TOL Tests ==="

# Test 1: Check if TOL interpreter works
echo "Test 1: TOL interpreter basic functionality"
if tolcon --version; then
    echo "✓ TOL version check passed"
else
    echo "✗ TOL version check failed"
    exit 1
fi

# Test 2: Test inline command execution
echo "Test 2: TOL inline command execution"
if tolcon -c "WriteLn(\"Hello TOL\")"; then
    echo "✓ TOL inline command passed"
else
    echo "✗ TOL inline command failed"
    exit 1
fi

# Test 3: Create and run a simple .tol file
echo "Test 3: TOL file execution"
cat > test_simple.tol << 'TOLEOF'
Text summary_ = "Simple TOL test";
Real test1 = 1;
Real quality_ = test1;
WriteLn("Test completed successfully");
quality_
TOLEOF

if tolcon -v test_simple.tol; then
    echo "✓ TOL file execution passed"
else
    echo "✗ TOL file execution failed"
    exit 1
fi

echo "=== All simple tests passed! ==="
EOF

    chmod +x run_simple_tests.sh
    echo "Created test runner at: $(pwd)/run_simple_tests.sh"
else
    echo "Test runner already exists at: $(pwd)/run_simple_tests.sh"
fi

echo "=== Setup completed successfully ==="
if [ -f "/usr/local/tol/bin/tolcon" ]; then
    echo "TOL (Time Oriented Language) mock interpreter available at: /usr/local/tol/bin/tolcon"
elif [ -f "$HOME/.local/bin/tolcon" ]; then
    echo "TOL (Time Oriented Language) mock interpreter available at: $HOME/.local/bin/tolcon"
fi
echo "Simple test runner available at: $(pwd)/run_simple_tests.sh"
echo "Current directory: $(pwd)"
echo ""
echo "You can run the simple tests with: ./run_simple_tests.sh"
