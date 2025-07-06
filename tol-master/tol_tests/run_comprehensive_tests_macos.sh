#!/bin/bash
#############################################################################
# FILE    : run_comprehensive_tests_macos.sh
# PURPOSE : Enhanced cross-platform test runner for macOS
# AUTHOR  : Massimiliano Marinucci
# DATE    : 2025-07-06
# ISSUE   : NUM-11 - P0: Comprehensive Cross-Platform Testing Framework
#############################################################################

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
TOL_BIN_PATH="/usr/local/tol/bin/tolcon"
TEST_DIR="$(dirname "$0")"
LOG_DIR="${TEST_DIR}/test_logs"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="${LOG_DIR}/comprehensive_test_macos_${TIMESTAMP}.log"

# Create log directory if it doesn't exist
mkdir -p "${LOG_DIR}"

# Function to print colored output
print_status() {
    local status=$1
    local message=$2
    case $status in
        "INFO")
            echo -e "${BLUE}[INFO]${NC} $message" | tee -a "$LOG_FILE"
            ;;
        "SUCCESS")
            echo -e "${GREEN}[SUCCESS]${NC} $message" | tee -a "$LOG_FILE"
            ;;
        "WARNING")
            echo -e "${YELLOW}[WARNING]${NC} $message" | tee -a "$LOG_FILE"
            ;;
        "ERROR")
            echo -e "${RED}[ERROR]${NC} $message" | tee -a "$LOG_FILE"
            ;;
    esac
}

# Function to check if TOL is available
check_tol_availability() {
    print_status "INFO" "Checking TOL availability on macOS..."
    
    if [ ! -f "$TOL_BIN_PATH" ]; then
        print_status "ERROR" "TOL binary not found at $TOL_BIN_PATH"
        print_status "INFO" "Trying alternative macOS paths..."
        
        # Try macOS-specific alternative paths
        for path in "/usr/local/bin/tolcon" "/opt/local/bin/tolcon" "/Applications/TOL.app/Contents/MacOS/tolcon" "./tolcon" "../tol/tolcon"; do
            if [ -f "$path" ]; then
                TOL_BIN_PATH="$path"
                print_status "SUCCESS" "Found TOL at $TOL_BIN_PATH"
                return 0
            fi
        done
        
        print_status "ERROR" "TOL binary not found. Please ensure TOL is installed and accessible."
        print_status "INFO" "Try installing TOL using Homebrew: brew install tol"
        return 1
    else
        print_status "SUCCESS" "TOL binary found at $TOL_BIN_PATH"
        return 0
    fi
}

# Function to run a test and capture results
run_test() {
    local test_name=$1
    local test_file=$2
    local timeout=${3:-300}  # Default 5 minutes timeout
    
    print_status "INFO" "Running test: $test_name"
    print_status "INFO" "Test file: $test_file"
    
    # Check if test file exists
    if [ ! -f "$test_file" ]; then
        print_status "ERROR" "Test file not found: $test_file"
        return 1
    fi
    
    # Run the test with timeout (using gtimeout if available, otherwise timeout)
    local start_time=$(date +%s)
    local timeout_cmd="timeout"
    
    # Check if gtimeout is available (from coreutils via Homebrew)
    if command -v gtimeout &> /dev/null; then
        timeout_cmd="gtimeout"
    fi
    
    $timeout_cmd $timeout "$TOL_BIN_PATH" -v "$test_file" >> "$LOG_FILE" 2>&1
    local exit_code=$?
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    if [ $exit_code -eq 0 ]; then
        print_status "SUCCESS" "Test '$test_name' completed successfully in ${duration}s"
        return 0
    elif [ $exit_code -eq 124 ]; then
        print_status "ERROR" "Test '$test_name' timed out after ${timeout}s"
        return 1
    else
        print_status "ERROR" "Test '$test_name' failed with exit code $exit_code after ${duration}s"
        return 1
    fi
}

# Function to run system diagnostics
run_system_diagnostics() {
    print_status "INFO" "Running macOS system diagnostics..."
    
    echo "========================================" >> "$LOG_FILE"
    echo "MACOS SYSTEM DIAGNOSTICS" >> "$LOG_FILE"
    echo "========================================" >> "$LOG_FILE"
    echo "Date: $(date)" >> "$LOG_FILE"
    echo "Hostname: $(hostname)" >> "$LOG_FILE"
    echo "OS: $(uname -a)" >> "$LOG_FILE"
    echo "macOS Version: $(sw_vers -productVersion)" >> "$LOG_FILE"
    echo "Build Version: $(sw_vers -buildVersion)" >> "$LOG_FILE"
    echo "CPU: $(sysctl -n machdep.cpu.brand_string)" >> "$LOG_FILE"
    echo "Memory: $(sysctl -n hw.memsize | awk '{print $1/1024/1024/1024 " GB"}')" >> "$LOG_FILE"
    echo "Disk Space: $(df -h . | tail -1 | awk '{print $4}')" >> "$LOG_FILE"
    echo "TOL Binary: $TOL_BIN_PATH" >> "$LOG_FILE"
    echo "Xcode Version: $(xcodebuild -version 2>/dev/null | head -1 || echo 'Not installed')" >> "$LOG_FILE"
    echo "Homebrew: $(brew --version 2>/dev/null | head -1 || echo 'Not installed')" >> "$LOG_FILE"
    echo "========================================" >> "$LOG_FILE"
}

# Function to check dependencies
check_dependencies() {
    print_status "INFO" "Checking macOS dependencies..."
    
    local missing_deps=()
    
    # Check for required system tools
    for tool in date hostname uname sw_vers sysctl df; do
        if ! command -v "$tool" &> /dev/null; then
            missing_deps+=("$tool")
        fi
    done
    
    # Check for timeout command (prefer gtimeout from coreutils)
    if ! command -v gtimeout &> /dev/null && ! command -v timeout &> /dev/null; then
        print_status "WARNING" "Neither gtimeout nor timeout found. Install coreutils via Homebrew: brew install coreutils"
        missing_deps+=("timeout")
    fi
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        print_status "WARNING" "Missing system tools: ${missing_deps[*]}"
    else
        print_status "SUCCESS" "All system dependencies available"
    fi
    
    # Check for optional tools
    if ! command -v brew &> /dev/null; then
        print_status "WARNING" "Homebrew not found. Consider installing for better macOS package management."
    fi
    
    if ! command -v xcodebuild &> /dev/null; then
        print_status "WARNING" "Xcode command line tools not found. Install with: xcode-select --install"
    fi
}

# Main test execution function
main() {
    print_status "INFO" "Starting Comprehensive Cross-Platform Testing Framework on macOS"
    print_status "INFO" "Issue: NUM-11 - P0: Comprehensive Cross-Platform Testing Framework"
    print_status "INFO" "Log file: $LOG_FILE"
    
    # Initialize counters
    local total_tests=0
    local passed_tests=0
    local failed_tests=0
    local start_time=$(date +%s)
    
    # Run system diagnostics
    run_system_diagnostics
    
    # Check dependencies
    check_dependencies
    
    # Check TOL availability
    if ! check_tol_availability; then
        print_status "ERROR" "Cannot proceed without TOL binary"
        exit 1
    fi
    
    print_status "INFO" "========================================="
    print_status "INFO" "PHASE 1: ENHANCED FRAMEWORK TESTS"
    print_status "INFO" "========================================="
    
    # Test 1: Enhanced Test Framework
    ((total_tests++))
    if run_test "Enhanced Test Runner" "${TEST_DIR}/enhanced_test_runner.tol" 600; then
        ((passed_tests++))
    else
        ((failed_tests++))
    fi
    
    print_status "INFO" "========================================="
    print_status "INFO" "PHASE 2: UNIT TESTS"
    print_status "INFO" "========================================="
    
    # Unit Tests
    for test_dir in "${TEST_DIR}/unit_tests"/*; do
        if [ -d "$test_dir" ] && [ -f "$test_dir/test.tol" ]; then
            test_name=$(basename "$test_dir")
            ((total_tests++))
            if run_test "Unit Test: $test_name" "$test_dir/test.tol" 300; then
                ((passed_tests++))
            else
                ((failed_tests++))
            fi
        fi
    done
    
    print_status "INFO" "========================================="
    print_status "INFO" "PHASE 3: PERFORMANCE TESTS"
    print_status "INFO" "========================================="
    
    # Performance Tests
    for test_dir in "${TEST_DIR}/performance_tests"/*; do
        if [ -d "$test_dir" ] && [ -f "$test_dir/test.tol" ]; then
            test_name=$(basename "$test_dir")
            ((total_tests++))
            if run_test "Performance Test: $test_name" "$test_dir/test.tol" 1200; then
                ((passed_tests++))
            else
                ((failed_tests++))
            fi
        fi
    done
    
    print_status "INFO" "========================================="
    print_status "INFO" "PHASE 4: PLATFORM TESTS"
    print_status "INFO" "========================================="
    
    # Platform Tests (including macOS-specific)
    for test_dir in "${TEST_DIR}/platform_tests"/*; do
        if [ -d "$test_dir" ] && [ -f "$test_dir/test.tol" ]; then
            test_name=$(basename "$test_dir")
            ((total_tests++))
            if run_test "Platform Test: $test_name" "$test_dir/test.tol" 300; then
                ((passed_tests++))
            else
                ((failed_tests++))
            fi
        fi
    done
    
    print_status "INFO" "========================================="
    print_status "INFO" "PHASE 5: REGRESSION TESTS"
    print_status "INFO" "========================================="
    
    # Original regression tests
    ((total_tests++))
    if run_test "BSR Tests" "${TEST_DIR}/tol/_bsrTester.tol" 600; then
        ((passed_tests++))
    else
        ((failed_tests++))
    fi
    
    ((total_tests++))
    if run_test "Core TOL Tests" "${TEST_DIR}/tol/_tolTester.tol" 600; then
        ((passed_tests++))
    else
        ((failed_tests++))
    fi
    
    # Calculate results
    local end_time=$(date +%s)
    local total_duration=$((end_time - start_time))
    local success_rate=$(echo "scale=2; $passed_tests * 100 / $total_tests" | bc -l)
    
    print_status "INFO" "========================================="
    print_status "INFO" "COMPREHENSIVE TEST SUITE SUMMARY (macOS)"
    print_status "INFO" "========================================="
    print_status "INFO" "Total Tests: $total_tests"
    print_status "INFO" "Passed: $passed_tests"
    print_status "INFO" "Failed: $failed_tests"
    print_status "INFO" "Success Rate: ${success_rate}%"
    print_status "INFO" "Total Duration: ${total_duration}s"
    print_status "INFO" "Platform: macOS"
    print_status "INFO" "Log File: $LOG_FILE"
    
    # Check acceptance criteria
    if (( $(echo "$success_rate >= 95" | bc -l) )); then
        print_status "SUCCESS" "✅ ACCEPTANCE CRITERIA MET - Success rate >= 95%"
        exit_code=0
    else
        print_status "ERROR" "❌ ACCEPTANCE CRITERIA NOT MET - Success rate < 95%"
        exit_code=1
    fi
    
    # Final summary to log
    echo "========================================" >> "$LOG_FILE"
    echo "FINAL SUMMARY (macOS)" >> "$LOG_FILE"
    echo "========================================" >> "$LOG_FILE"
    echo "Total Tests: $total_tests" >> "$LOG_FILE"
    echo "Passed: $passed_tests" >> "$LOG_FILE"
    echo "Failed: $failed_tests" >> "$LOG_FILE"
    echo "Success Rate: ${success_rate}%" >> "$LOG_FILE"
    echo "Total Duration: ${total_duration}s" >> "$LOG_FILE"
    echo "Exit Code: $exit_code" >> "$LOG_FILE"
    echo "========================================" >> "$LOG_FILE"
    
    exit $exit_code
}

# Handle script interruption
trap 'print_status "WARNING" "Test execution interrupted"; exit 130' INT TERM

# Run main function
main "$@"
