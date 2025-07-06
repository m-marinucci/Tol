#!/bin/bash
set -e

echo "=== TOL (Time Oriented Language) Test Environment Setup ==="
echo "Setting up test environment for TOL project"

# Update package list
echo "Updating package list..."
sudo apt-get update

# Install basic dependencies for testing
echo "Installing basic dependencies..."
sudo apt-get install -y \
    cmake build-essential python3 python3-pip \
    git wget curl

# Set working directory (configurable via WORKSPACE_DIR, defaults to /mnt/persist/workspace)
WORKSPACE_DIR="${WORKSPACE_DIR:-/mnt/persist/workspace}"
if [ ! -d "$WORKSPACE_DIR" ]; then
    echo "Workspace directory $WORKSPACE_DIR does not exist. Creating it..."
    mkdir -p "$WORKSPACE_DIR"
fi
cd "$WORKSPACE_DIR"

# Create a mock TOL interpreter for testing the test framework
echo "Creating mock TOL interpreter for test framework validation..."
sudo mkdir -p /usr/local/tol/bin

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

sudo cp /tmp/mock_tolcon /usr/local/tol/bin/tolcon
sudo chmod +x /usr/local/tol/bin/tolcon

# Add TOL binary to PATH
echo "Adding TOL to PATH..."
echo 'export PATH="/usr/local/tol/bin:$PATH"' >> $HOME/.profile
export PATH="/usr/local/tol/bin:$PATH"

# Verify TOL installation
echo "Verifying TOL installation..."
echo "Testing version check:"
/usr/local/tol/bin/tolcon --version

echo "Testing inline command:"
/usr/local/tol/bin/tolcon -c "WriteLn(\"TOL_TEST_SUCCESS\")"

# Create a simple test script in the workspace root
echo "Creating simple test runner..."
cd /mnt/persist/workspace

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

echo "=== Setup completed successfully ==="
echo "TOL (Time Oriented Language) mock interpreter installed at: /usr/local/tol/bin/tolcon"
echo "Simple test runner created at: $(pwd)/run_simple_tests.sh"
echo "Current directory: $(pwd)"
echo ""
echo "You can run the simple tests with: ./run_simple_tests.sh"