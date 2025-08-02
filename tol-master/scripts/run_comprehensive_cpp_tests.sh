#!/bin/bash

# Comprehensive C++ Standards and Thread Safety Test Runner
# This script runs all C++ compatibility and thread safety tests locally

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
TOL_DIR="$PROJECT_ROOT/tol-master/tol"
TESTS_DIR="$PROJECT_ROOT/tol-master/tol_tests"
BUILD_DIR="$TOL_DIR/build-cpp-tests"
RESULTS_DIR="$PROJECT_ROOT/test-results"
LOG_FILE="$RESULTS_DIR/comprehensive_cpp_tests.log"

# Test configuration
DEFAULT_COMPILERS="gcc-11 clang-14"
DEFAULT_CPP_STANDARDS="17 20"
DEFAULT_SANITIZERS="address thread undefined"
ENABLE_THREAD_TESTS=${ENABLE_THREAD_TESTS:-true}
ENABLE_SANITIZER_TESTS=${ENABLE_SANITIZER_TESTS:-true}
ENABLE_PERFORMANCE_TESTS=${ENABLE_PERFORMANCE_TESTS:-true}
PARALLEL_JOBS=${PARALLEL_JOBS:-$(nproc)}

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1" | tee -a "$LOG_FILE"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" | tee -a "$LOG_FILE"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
}

# Usage information
show_usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Options:
    --compilers COMPILERS    Space-separated list of compilers (default: $DEFAULT_COMPILERS)
    --cpp-standards STDS     Space-separated list of C++ standards (default: $DEFAULT_CPP_STANDARDS)
    --sanitizers SANITIZERS  Space-separated list of sanitizers (default: $DEFAULT_SANITIZERS)
    --no-thread-tests        Disable thread safety tests
    --no-sanitizer-tests     Disable sanitizer tests
    --no-performance-tests   Disable performance tests
    --jobs N                 Number of parallel jobs (default: $PARALLEL_JOBS)
    --clean                  Clean build directories before testing
    --help                   Show this help message

Examples:
    $0                                          # Run all tests with defaults
    $0 --compilers "gcc-11" --cpp-standards "17"   # Test only GCC 11 with C++17
    $0 --no-sanitizer-tests --jobs 4           # Skip sanitizers, use 4 jobs
    $0 --clean                                  # Clean build and run all tests
EOF
}

# Parse command line arguments
COMPILERS="$DEFAULT_COMPILERS"
CPP_STANDARDS="$DEFAULT_CPP_STANDARDS"
SANITIZERS="$DEFAULT_SANITIZERS"
CLEAN_BUILD=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --compilers)
            COMPILERS="$2"
            shift 2
            ;;
        --cpp-standards)
            CPP_STANDARDS="$2"
            shift 2
            ;;
        --sanitizers)
            SANITIZERS="$2"
            shift 2
            ;;
        --no-thread-tests)
            ENABLE_THREAD_TESTS=false
            shift
            ;;
        --no-sanitizer-tests)
            ENABLE_SANITIZER_TESTS=false
            shift
            ;;
        --no-performance-tests)
            ENABLE_PERFORMANCE_TESTS=false
            shift
            ;;
        --jobs)
            PARALLEL_JOBS="$2"
            shift 2
            ;;
        --clean)
            CLEAN_BUILD=true
            shift
            ;;
        --help)
            show_usage
            exit 0
            ;;
        *)
            log_error "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
done

# Initialize
mkdir -p "$RESULTS_DIR"
echo "Comprehensive C++ Standards and Thread Safety Test Run - $(date)" > "$LOG_FILE"

log_info "Starting comprehensive C++ tests..."
log_info "Project root: $PROJECT_ROOT"
log_info "TOL directory: $TOL_DIR"
log_info "Results directory: $RESULTS_DIR"
log_info "Compilers: $COMPILERS"
log_info "C++ standards: $CPP_STANDARDS"
log_info "Sanitizers: $SANITIZERS"
log_info "Parallel jobs: $PARALLEL_JOBS"

# Check dependencies
check_dependencies() {
    log_info "Checking dependencies..."
    
    local missing_deps=()
    
    # Check compilers
    for compiler in $COMPILERS; do
        if ! command -v "$compiler" &> /dev/null; then
            missing_deps+=("$compiler")
        fi
    done
    
    # Check other tools
    for tool in cmake make ccache; do
        if ! command -v "$tool" &> /dev/null; then
            missing_deps+=("$tool")
        fi
    done
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        log_error "Missing dependencies: ${missing_deps[*]}"
        log_info "Please install missing dependencies and try again"
        exit 1
    fi
    
    log_success "All dependencies found"
}

# Clean build directories
clean_builds() {
    if [ "$CLEAN_BUILD" = true ]; then
        log_info "Cleaning build directories..."
        rm -rf "$BUILD_DIR"
        rm -rf "$TOL_DIR"/build-*
        log_success "Build directories cleaned"
    fi
}

# Test C++ standards compatibility
test_cpp_standards() {
    log_info "Testing C++ standards compatibility..."
    
    local test_results=()
    
    for compiler in $COMPILERS; do
        for std in $CPP_STANDARDS; do
            log_info "Testing $compiler with C++$std..."
            
            local build_name="cpp${std}-${compiler}"
            local test_build_dir="$BUILD_DIR/$build_name"
            
            mkdir -p "$test_build_dir"
            cd "$test_build_dir"
            
            # Determine C compiler from C++ compiler name
            C_COMPILER="$(echo $compiler | sed 's/g++/gcc/' | sed 's/clang++/clang/')"
            if ! command -v "$C_COMPILER" >/dev/null 2>&1; then
                log_error "C compiler '$C_COMPILER' (derived from '$compiler') not found. Skipping $compiler C++$std."
                test_results+=("$build_name:FAILED:missing_c_compiler")
                continue
            fi
            # Configure
            if ! cmake "$TOL_DIR" \
                -DCMAKE_BUILD_TYPE=Release \
                -DCMAKE_CXX_STANDARD="$std" \
                -DCMAKE_CXX_STANDARD_REQUIRED=ON \
                -DCMAKE_CXX_EXTENSIONS=OFF \
                -DCMAKE_C_COMPILER="$C_COMPILER" \
                -DCMAKE_CXX_COMPILER="$compiler" \
                -DENABLE_TESTING=ON \
                >> "$LOG_FILE" 2>&1; then
                
                log_error "CMake configuration failed for $compiler C++$std"
                test_results+=("$build_name:FAILED:configure")
                continue
            fi
            
            # Build
            if ! make -j"$PARALLEL_JOBS" >> "$LOG_FILE" 2>&1; then
                log_error "Build failed for $compiler C++$std"
                test_results+=("$build_name:FAILED:build")
                continue
            fi
            
            # Test basic functionality
            if [ -f "./tolcon" ]; then
                if ./tolcon --version >> "$LOG_FILE" 2>&1 && \
                   ./tolcon -c 'WriteLn("C++'"$std"' test: PASSED");' >> "$LOG_FILE" 2>&1; then
                    log_success "$compiler C++$std: PASSED"
                    test_results+=("$build_name:PASSED:basic")
                else
                    log_error "$compiler C++$std: Basic test failed"
                    test_results+=("$build_name:FAILED:basic")
                fi
            else
                log_error "$compiler C++$std: tolcon executable not found"
                test_results+=("$build_name:FAILED:missing_executable")
            fi
        done
    done
    
    # Save results
    printf '%s\n' "${test_results[@]}" > "$RESULTS_DIR/cpp_standards_results.txt"
    
    cd "$PROJECT_ROOT"
}

# Test thread safety
test_thread_safety() {
    if [ "$ENABLE_THREAD_TESTS" = false ]; then
        log_info "Thread safety tests disabled"
        return
    fi
    
    log_info "Testing thread safety..."
    
    local thread_test_dir="$TESTS_DIR/unit_tests/thread_safety"
    
    if [ ! -d "$thread_test_dir" ]; then
        log_warning "Thread safety test directory not found: $thread_test_dir"
        return
    fi
    
    local thread_build_dir="$BUILD_DIR/thread_safety"
    mkdir -p "$thread_build_dir"
    cd "$thread_build_dir"
    
    # Build thread safety tests
    if ! cmake "$thread_test_dir" \
        -DCMAKE_BUILD_TYPE=Debug \
        -DCMAKE_CXX_STANDARD=17 \
        -DENABLE_TESTING=ON \
        >> "$LOG_FILE" 2>&1; then
        
        log_error "Thread safety test configuration failed"
        return
    fi
    
    if ! make -j"$PARALLEL_JOBS" >> "$LOG_FILE" 2>&1; then
        log_error "Thread safety test build failed"
        return
    fi
    
    # Run thread safety tests
    local thread_results=()
    
    if [ -f "./multi_threaded_init_test" ]; then
        log_info "Running basic thread safety test..."
        if ./multi_threaded_init_test --threads 8 --duration 3000 >> "$LOG_FILE" 2>&1; then
            log_success "Basic thread safety test: PASSED"
            thread_results+=("basic:PASSED")
        else
            log_error "Basic thread safety test: FAILED"
            thread_results+=("basic:FAILED")
        fi
        
        log_info "Running stress thread safety test..."
        if ./multi_threaded_init_test --threads 16 --stress --duration 5000 >> "$LOG_FILE" 2>&1; then
            log_success "Stress thread safety test: PASSED"
            thread_results+=("stress:PASSED")
        else
            log_error "Stress thread safety test: FAILED"
            thread_results+=("stress:FAILED")
        fi
    else
        log_error "Thread safety test executable not found"
        thread_results+=("missing_executable:FAILED")
    fi
    
    # Save results
    printf '%s\n' "${thread_results[@]}" > "$RESULTS_DIR/thread_safety_results.txt"
    
    cd "$PROJECT_ROOT"
}

# Test with sanitizers
test_sanitizers() {
    if [ "$ENABLE_SANITIZER_TESTS" = false ]; then
        log_info "Sanitizer tests disabled"
        return
    fi
    
    log_info "Testing with sanitizers..."
    
    local sanitizer_results=()
    
    for sanitizer in $SANITIZERS; do
        log_info "Testing with ${sanitizer}sanitizer..."
        
        local sanitizer_build_dir="$BUILD_DIR/sanitizer-$sanitizer"
        mkdir -p "$sanitizer_build_dir"
        cd "$sanitizer_build_dir"
        
        # Set sanitizer flags
        local sanitizer_flags
        local env_vars
        
        case $sanitizer in
            address)
                sanitizer_flags="-fsanitize=address -fno-omit-frame-pointer"
                env_vars="ASAN_OPTIONS=detect_leaks=1:abort_on_error=1"
                ;;
            thread)
                sanitizer_flags="-fsanitize=thread -fno-omit-frame-pointer"
                env_vars="TSAN_OPTIONS=abort_on_error=1"
                ;;
            undefined)
                sanitizer_flags="-fsanitize=undefined -fno-omit-frame-pointer"
                env_vars="UBSAN_OPTIONS=abort_on_error=1"
                ;;
            *)
                log_warning "Unknown sanitizer: $sanitizer"
                continue
                ;;
        esac
        
        # Configure with sanitizer
        if ! cmake "$TOL_DIR" \
            -DCMAKE_BUILD_TYPE=Debug \
            -DCMAKE_CXX_STANDARD=17 \
            -DCMAKE_CXX_FLAGS="-g -O1 $sanitizer_flags" \
            -DCMAKE_C_FLAGS="-g -O1 $sanitizer_flags" \
            -DCMAKE_EXE_LINKER_FLAGS="$sanitizer_flags" \
            -DENABLE_TESTING=ON \
            >> "$LOG_FILE" 2>&1; then
            
            log_error "${sanitizer}sanitizer configuration failed"
            sanitizer_results+=("$sanitizer:FAILED:configure")
            continue
        fi
        
        # Build with sanitizer
        if ! make -j"$PARALLEL_JOBS" >> "$LOG_FILE" 2>&1; then
            log_error "${sanitizer}sanitizer build failed"
            sanitizer_results+=("$sanitizer:FAILED:build")
            continue
        fi
        
        # Test with sanitizer
        if [ -f "./tolcon" ]; then
            log_info "Running ${sanitizer}sanitizer tests..."
            
            if eval "$env_vars ./tolcon --version" >> "$LOG_FILE" 2>&1 && \
               eval "$env_vars ./tolcon -c 'Real x = Sqrt(25); WriteLn(x);'" >> "$LOG_FILE" 2>&1; then
                log_success "${sanitizer}sanitizer test: PASSED"
                sanitizer_results+=("$sanitizer:PASSED")
            else
                log_error "${sanitizer}sanitizer test: FAILED"
                sanitizer_results+=("$sanitizer:FAILED:runtime")
            fi
        else
            log_error "${sanitizer}sanitizer: tolcon executable not found"
            sanitizer_results+=("$sanitizer:FAILED:missing_executable")
        fi
    done
    
    # Save results
    printf '%s\n' "${sanitizer_results[@]}" > "$RESULTS_DIR/sanitizer_results.txt"
    
    cd "$PROJECT_ROOT"
}

# Run performance tests
test_performance() {
    if [ "$ENABLE_PERFORMANCE_TESTS" = false ]; then
        log_info "Performance tests disabled"
        return
    fi
    
    log_info "Running performance tests..."
    
    # Use the best performing build (Release with GCC)
    local perf_build_dir="$BUILD_DIR/performance"
    mkdir -p "$perf_build_dir"
    cd "$perf_build_dir"
    
    if ! cmake "$TOL_DIR" \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_CXX_STANDARD=17 \
        -DENABLE_TESTING=ON \
        >> "$LOG_FILE" 2>&1; then
        
        log_error "Performance test configuration failed"
        return
    fi
    
    if ! make -j"$PARALLEL_JOBS" >> "$LOG_FILE" 2>&1; then
        log_error "Performance test build failed"
        return
    fi
    
    if [ -f "./tolcon" ]; then
        log_info "Running performance benchmarks..."
        
        local perf_results=()
        
        # Arithmetic performance
        local start_time=$(date +%s%N)
        ./tolcon -c 'Real x = 0; For(Real i=1, i<=100000, i++, x = x + i*i); WriteLn("Result: ", x);' >> "$LOG_FILE" 2>&1
        local end_time=$(date +%s%N)
        local arithmetic_time=$(echo "scale=3; ($end_time - $start_time) / 1000000000" | bc)
        
        log_info "Arithmetic performance: ${arithmetic_time}s"
        perf_results+=("arithmetic:${arithmetic_time}s")
        
        # Matrix performance (if available)
        start_time=$(date +%s%N)
        ./tolcon -c 'Matrix m = [[1,2,3],[4,5,6],[7,8,9]]; Real det = MatDet(m); WriteLn("Determinant: ", det);' >> "$LOG_FILE" 2>&1 || true
        end_time=$(date +%s%N)
        local matrix_time=$(echo "scale=3; ($end_time - $start_time) / 1000000000" | bc)
        
        log_info "Matrix performance: ${matrix_time}s"
        perf_results+=("matrix:${matrix_time}s")
        
        # Save results
        printf '%s\n' "${perf_results[@]}" > "$RESULTS_DIR/performance_results.txt"
        
        log_success "Performance tests completed"
    else
        log_error "Performance test: tolcon executable not found"
    fi
    
    cd "$PROJECT_ROOT"
}

# Generate comprehensive report
generate_report() {
    log_info "Generating comprehensive test report..."
    
    local report_file="$RESULTS_DIR/comprehensive_test_report.md"
    
    cat > "$report_file" << EOF
# Comprehensive C++ Standards and Thread Safety Test Report

Generated on: $(date)

## Test Configuration

- **Compilers tested**: $COMPILERS
- **C++ standards tested**: $CPP_STANDARDS
- **Sanitizers tested**: $SANITIZERS
- **Parallel jobs**: $PARALLEL_JOBS
- **Thread tests enabled**: $ENABLE_THREAD_TESTS
- **Sanitizer tests enabled**: $ENABLE_SANITIZER_TESTS
- **Performance tests enabled**: $ENABLE_PERFORMANCE_TESTS

## Test Results Summary

EOF
    
    # C++ Standards Results
    echo "### C++ Standards Compatibility" >> "$report_file"
    echo "" >> "$report_file"
    
    if [ -f "$RESULTS_DIR/cpp_standards_results.txt" ]; then
        echo "| Compiler + Standard | Status | Stage |" >> "$report_file"
        echo "|---------------------|--------|-------|" >> "$report_file"
        
        while IFS=':' read -r build_name status stage; do
            echo "| $build_name | $status | $stage |" >> "$report_file"
        done < "$RESULTS_DIR/cpp_standards_results.txt"
    else
        echo "No C++ standards results available." >> "$report_file"
    fi
    
    echo "" >> "$report_file"
    
    # Thread Safety Results
    echo "### Thread Safety Tests" >> "$report_file"
    echo "" >> "$report_file"
    
    if [ -f "$RESULTS_DIR/thread_safety_results.txt" ]; then
        echo "| Test Type | Status |" >> "$report_file"
        echo "|-----------|--------|" >> "$report_file"
        
        while IFS=':' read -r test_type status; do
            echo "| $test_type | $status |" >> "$report_file"
        done < "$RESULTS_DIR/thread_safety_results.txt"
    else
        echo "Thread safety tests were not run." >> "$report_file"
    fi
    
    echo "" >> "$report_file"
    
    # Sanitizer Results
    echo "### Sanitizer Tests" >> "$report_file"
    echo "" >> "$report_file"
    
    if [ -f "$RESULTS_DIR/sanitizer_results.txt" ]; then
        echo "| Sanitizer | Status | Stage |" >> "$report_file"
        echo "|-----------|--------|-------|" >> "$report_file"
        
        while IFS=':' read -r sanitizer status stage; do
            if [ -n "$stage" ]; then
                echo "| $sanitizer | $status | $stage |" >> "$report_file"
            else
                echo "| $sanitizer | $status | runtime |" >> "$report_file"
            fi
        done < "$RESULTS_DIR/sanitizer_results.txt"
    else
        echo "Sanitizer tests were not run." >> "$report_file"
    fi
    
    echo "" >> "$report_file"
    
    # Performance Results
    echo "### Performance Tests" >> "$report_file"
    echo "" >> "$report_file"
    
    if [ -f "$RESULTS_DIR/performance_results.txt" ]; then
        echo "| Test Type | Execution Time |" >> "$report_file"
        echo "|-----------|----------------|" >> "$report_file"
        
        while IFS=':' read -r test_type time; do
            echo "| $test_type | $time |" >> "$report_file"
        done < "$RESULTS_DIR/performance_results.txt"
    else
        echo "Performance tests were not run." >> "$report_file"
    fi
    
    echo "" >> "$report_file"
    echo "## Detailed Logs" >> "$report_file"
    echo "" >> "$report_file"
    echo "Full test logs are available in: \`$LOG_FILE\`" >> "$report_file"
    
    log_success "Comprehensive test report generated: $report_file"
}

# Main execution
main() {
    check_dependencies
    clean_builds
    test_cpp_standards
    test_thread_safety
    test_sanitizers
    test_performance
    generate_report
    
    log_success "Comprehensive C++ tests completed!"
    log_info "Results directory: $RESULTS_DIR"
    log_info "Full log: $LOG_FILE"
    log_info "Report: $RESULTS_DIR/comprehensive_test_report.md"
    
    # Return appropriate exit code
    local failed_tests=0
    
    # Check for failures in any test category
    if [ -f "$RESULTS_DIR/cpp_standards_results.txt" ]; then
        failed_tests=$((failed_tests + $(grep -c "FAILED" "$RESULTS_DIR/cpp_standards_results.txt" || echo 0)))
    fi
    
    if [ -f "$RESULTS_DIR/thread_safety_results.txt" ]; then
        failed_tests=$((failed_tests + $(grep -c "FAILED" "$RESULTS_DIR/thread_safety_results.txt" || echo 0)))
    fi
    
    if [ -f "$RESULTS_DIR/sanitizer_results.txt" ]; then
        failed_tests=$((failed_tests + $(grep -c "FAILED" "$RESULTS_DIR/sanitizer_results.txt" || echo 0)))
    fi
    
    if [ $failed_tests -gt 0 ]; then
        log_error "Some tests failed ($failed_tests failures detected)"
        exit 1
    else
        log_success "All tests passed!"
        exit 0
    fi
}

# Run main function
main "$@"