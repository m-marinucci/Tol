#!/bin/bash
# Performance monitoring script for TOL CI/CD pipeline
# This script runs performance benchmarks and detects regressions

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOL_BIN="${1:-./tol/build/bin/tolcon}"
RESULTS_FILE="${2:-performance_results.json}"
BASELINE_FILE="${3:-performance_baseline.json}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if TOL binary exists
if [ ! -f "$TOL_BIN" ]; then
    log_error "TOL binary not found: $TOL_BIN"
    exit 1
fi

log_info "Starting performance benchmarks with: $TOL_BIN"

# Create results directory
mkdir -p "$(dirname "$RESULTS_FILE")"

# System information
get_system_info() {
    cat << EOF
{
    "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "system": {
        "os": "$(uname -s)",
        "kernel": "$(uname -r)",
        "arch": "$(uname -m)",
        "cpu": "$(lscpu | grep 'Model name' | cut -d: -f2 | xargs || echo 'Unknown')",
        "memory": "$(free -h | grep Mem | awk '{print $2}' || echo 'Unknown')",
        "cores": "$(nproc || echo 'Unknown')"
    },
    "benchmarks": [
EOF
}

# Run a single benchmark
run_benchmark() {
    local name="$1"
    local description="$2"
    local command="$3"
    local iterations="${4:-3}"
    
    log_info "Running benchmark: $name"
    
    local total_time=0
    local total_memory=0
    local times=()
    local memories=()
    
    for i in $(seq 1 $iterations); do
        log_info "  Iteration $i/$iterations"
        
        # Run the command with time measurement
        local time_output
        time_output=$(/usr/bin/time -f "%e %M" $command 2>&1 >/dev/null || echo "0 0")
        
        local time_taken=$(echo "$time_output" | awk '{print $1}')
        local memory_used=$(echo "$time_output" | awk '{print $2}')
        
        times+=("$time_taken")
        memories+=("$memory_used")
        
        total_time=$(echo "$total_time + $time_taken" | bc -l)
        total_memory=$(echo "$total_memory + $memory_used" | bc -l)
    done
    
    local avg_time=$(echo "scale=3; $total_time / $iterations" | bc -l)
    local avg_memory=$(echo "scale=0; $total_memory / $iterations" | bc -l)
    
    # Calculate standard deviation for time
    local sum_sq_diff=0
    for time in "${times[@]}"; do
        local diff=$(echo "$time - $avg_time" | bc -l)
        local sq_diff=$(echo "$diff * $diff" | bc -l)
        sum_sq_diff=$(echo "$sum_sq_diff + $sq_diff" | bc -l)
    done
    local variance=$(echo "scale=6; $sum_sq_diff / $iterations" | bc -l)
    local std_dev=$(echo "scale=3; sqrt($variance)" | bc -l)
    
    # Output JSON for this benchmark
    cat << EOF
        {
            "name": "$name",
            "description": "$description",
            "iterations": $iterations,
            "results": {
                "avg_time_seconds": $avg_time,
                "std_dev_seconds": $std_dev,
                "avg_memory_kb": $avg_memory,
                "all_times": [$(IFS=,; echo "${times[*]}")],
                "all_memories": [$(IFS=,; echo "${memories[*]}")]
            }
        }
EOF
}

# Performance benchmarks
run_benchmarks() {
    local first=true
    
    # Benchmark 1: Basic arithmetic operations
    if [ "$first" = true ]; then
        first=false
    else
        echo ","
    fi
    run_benchmark \
        "arithmetic_performance" \
        "Basic arithmetic operations (1M iterations)" \
        "$TOL_BIN -c \"Real x = 0; For(Real i=1, i<=1000000, i++, x = x + i*i); WriteLn(x)\"" \
        3
    
    # Benchmark 2: Version check (startup time)
    echo ","
    run_benchmark \
        "startup_time" \
        "Application startup time" \
        "$TOL_BIN --version" \
        5
    
    # Benchmark 3: Help command
    echo ","
    run_benchmark \
        "help_command" \
        "Help command execution" \
        "$TOL_BIN --help" \
        3
    
    # Benchmark 4: Simple calculation
    echo ","
    run_benchmark \
        "simple_calculation" \
        "Simple mathematical calculation" \
        "$TOL_BIN -c \"WriteLn(Sqrt(2) + Sin(Pi/4))\"" \
        5
}

# Compare with baseline
compare_with_baseline() {
    if [ ! -f "$BASELINE_FILE" ]; then
        log_warn "No baseline file found: $BASELINE_FILE"
        log_info "Current results will serve as baseline"
        cp "$RESULTS_FILE" "$BASELINE_FILE"
        return 0
    fi
    
    log_info "Comparing with baseline: $BASELINE_FILE"
    
    # Simple comparison using jq (if available)
    if command -v jq &> /dev/null; then
        local regression_detected=false
        
        # Extract benchmark names and compare
        local benchmarks
        benchmarks=$(jq -r '.benchmarks[].name' "$RESULTS_FILE")
        
        for benchmark in $benchmarks; do
            local current_time
            local baseline_time
            
            current_time=$(jq -r ".benchmarks[] | select(.name == \"$benchmark\") | .results.avg_time_seconds" "$RESULTS_FILE")
            baseline_time=$(jq -r ".benchmarks[] | select(.name == \"$benchmark\") | .results.avg_time_seconds" "$BASELINE_FILE" 2>/dev/null || echo "0")
            
            if [ "$baseline_time" != "0" ] && [ "$baseline_time" != "null" ]; then
                local ratio
                ratio=$(echo "scale=2; $current_time / $baseline_time" | bc -l)
                local percentage
                percentage=$(echo "scale=1; ($ratio - 1) * 100" | bc -l)
                
                if (( $(echo "$ratio > 1.1" | bc -l) )); then
                    log_error "Performance regression detected in $benchmark: ${percentage}% slower"
                    regression_detected=true
                elif (( $(echo "$ratio < 0.9" | bc -l) )); then
                    log_info "Performance improvement in $benchmark: ${percentage}% faster"
                else
                    log_info "Performance stable for $benchmark: ${percentage}% change"
                fi
            fi
        done
        
        if [ "$regression_detected" = true ]; then
            log_error "Performance regressions detected!"
            return 1
        else
            log_info "No significant performance regressions detected"
            return 0
        fi
    else
        log_warn "jq not available, skipping detailed comparison"
        return 0
    fi
}

# Main execution
main() {
    log_info "TOL Performance Monitor"
    log_info "======================"
    
    # Generate results file
    {
        get_system_info
        run_benchmarks
        echo ""
        echo "    ]"
        echo "}"
    } > "$RESULTS_FILE"
    
    log_info "Performance results saved to: $RESULTS_FILE"
    
    # Compare with baseline
    compare_with_baseline
    local comparison_result=$?
    
    # Display summary
    log_info "Performance monitoring completed"
    
    if command -v jq &> /dev/null; then
        echo ""
        log_info "Benchmark Summary:"
        jq -r '.benchmarks[] | "  \(.name): \(.results.avg_time_seconds)s (±\(.results.std_dev_seconds)s)"' "$RESULTS_FILE"
    fi
    
    return $comparison_result
}

# Run main function
main "$@"
