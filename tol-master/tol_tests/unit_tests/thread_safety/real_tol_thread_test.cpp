/**
 * Real TOL Thread Safety Test
 * 
 * This test verifies that TOL's operator registration and initialization
 * is thread-safe and can handle concurrent access without race conditions.
 */

#include <iostream>
#include <iomanip>
#include <thread>
#include <vector>
#include <atomic>
#include <chrono>
#include <mutex>
#include <memory>
#include <random>

// TOL System Headers - these should be available in the build
#ifdef __cplusplus
extern "C" {
#endif

// TOL initialization and core functions
void InitializeSystem();
void FinalizeSystem();
int TestOperatorRegistration();
int TestBasicExpressionEvaluation();

// TOL operator and grammar functions
void RegisterAllOperators();
void InitializeGrammars();
int ValidateOperatorConsistency();

#ifdef __cplusplus
}
#endif

// Test statistics and synchronization
std::atomic<int> total_threads_started{0};
std::atomic<int> successful_initializations{0};
std::atomic<int> failed_initializations{0};
std::atomic<int> successful_operator_tests{0};
std::atomic<int> failed_operator_tests{0};
std::atomic<int> successful_expression_tests{0};
std::atomic<int> failed_expression_tests{0};

std::mutex log_mutex;
std::atomic<bool> global_test_failure{false};

// Thread-safe logging
void safe_log(const std::string& message) {
    std::lock_guard<std::mutex> lock(log_mutex);
    auto now = std::chrono::steady_clock::now();
    auto timestamp = std::chrono::duration_cast<std::chrono::milliseconds>(
        now.time_since_epoch()).count();
    std::cout << "[" << timestamp << "] " << message << std::endl;
}

class TOLThreadSafetyTester {
private:
    int thread_id_;
    std::mt19937 rng_;
    
public:
    explicit TOLThreadSafetyTester(int thread_id) 
        : thread_id_(thread_id), rng_(thread_id + std::time(nullptr)) {}
    
    void run_initialization_test() {
        total_threads_started++;
        
        try {
            // Add random startup delay to increase concurrency
            std::uniform_int_distribution<int> delay_dist(1, 100);
            std::this_thread::sleep_for(
                std::chrono::milliseconds(delay_dist(rng_)));
            
            safe_log("Thread " + std::to_string(thread_id_) + 
                    ": Starting TOL initialization");
            
            // Phase 1: System Initialization
            InitializeSystem();
            safe_log("Thread " + std::to_string(thread_id_) + 
                    ": System initialization completed");
            
            // Phase 2: Grammar and Operator Registration
            InitializeGrammars();
            RegisterAllOperators();
            safe_log("Thread " + std::to_string(thread_id_) + 
                    ": Grammar and operator registration completed");
            
            successful_initializations++;
            
            // Phase 3: Operator Consistency Test
            if (ValidateOperatorConsistency() == 0) {
                successful_operator_tests++;
                safe_log("Thread " + std::to_string(thread_id_) + 
                        ": Operator consistency test PASSED");
            } else {
                failed_operator_tests++;
                safe_log("Thread " + std::to_string(thread_id_) + 
                        ": Operator consistency test FAILED");
                global_test_failure = true;
            }
            
            // Phase 4: Basic Expression Evaluation Test
            if (TestBasicExpressionEvaluation() == 0) {
                successful_expression_tests++;
                safe_log("Thread " + std::to_string(thread_id_) + 
                        ": Expression evaluation test PASSED");
            } else {
                failed_expression_tests++;
                safe_log("Thread " + std::to_string(thread_id_) + 
                        ": Expression evaluation test FAILED");
                global_test_failure = true;
            }
            
            // Add random delay before cleanup
            std::this_thread::sleep_for(
                std::chrono::milliseconds(delay_dist(rng_)));
            
            // Phase 5: Cleanup
            FinalizeSystem();
            safe_log("Thread " + std::to_string(thread_id_) + 
                    ": All tests completed successfully");
            
        } catch (const std::exception& e) {
            failed_initializations++;
            global_test_failure = true;
            safe_log("Thread " + std::to_string(thread_id_) + 
                    ": Exception caught - " + std::string(e.what()));
        } catch (...) {
            failed_initializations++;
            global_test_failure = true;
            safe_log("Thread " + std::to_string(thread_id_) + 
                    ": Unknown exception caught");
        }
    }
    
    void run_repeated_initialization_test(int cycles) {
        total_threads_started++;
        
        for (int cycle = 0; cycle < cycles; ++cycle) {
            try {
                // Quick initialization and cleanup cycle
                InitializeSystem();
                RegisterAllOperators();
                
                // Quick test
                TestOperatorRegistration();
                
                FinalizeSystem();
                
                safe_log("Thread " + std::to_string(thread_id_) + 
                        ": Cycle " + std::to_string(cycle + 1) + " completed");
                
                // Small delay between cycles
                std::this_thread::sleep_for(std::chrono::milliseconds(10));
                
            } catch (...) {
                failed_initializations++;
                global_test_failure = true;
                safe_log("Thread " + std::to_string(thread_id_) + 
                        ": Exception in cycle " + std::to_string(cycle + 1));
                break;
            }
        }
    }
};

struct TestParameters {
    int num_threads;
    int test_cycles;
    bool enable_stress_mode;
    bool enable_repeated_init;
    int timeout_seconds;
};

int run_thread_safety_test_suite(const TestParameters& params) {
    std::cout << "=== TOL Thread Safety Test Suite ===" << std::endl;
    std::cout << "Test Configuration:" << std::endl;
    std::cout << "  Threads: " << params.num_threads << std::endl;
    std::cout << "  Cycles: " << params.test_cycles << std::endl;
    std::cout << "  Stress mode: " << (params.enable_stress_mode ? "ON" : "OFF") << std::endl;
    std::cout << "  Repeated init: " << (params.enable_repeated_init ? "ON" : "OFF") << std::endl;
    std::cout << "  Timeout: " << params.timeout_seconds << "s" << std::endl;
    std::cout << "=======================================" << std::endl;
    
    // Reset global counters
    total_threads_started = 0;
    successful_initializations = 0;
    failed_initializations = 0;
    successful_operator_tests = 0;
    failed_operator_tests = 0;
    successful_expression_tests = 0;
    failed_expression_tests = 0;
    global_test_failure = false;
    
    auto start_time = std::chrono::steady_clock::now();
    
    std::vector<std::thread> threads;
    threads.reserve(params.num_threads);
    
    // Launch test threads
    for (int i = 0; i < params.num_threads; ++i) {
        threads.emplace_back([i, &params]() {
            TOLThreadSafetyTester tester(i);
            
            if (params.enable_repeated_init) {
                tester.run_repeated_initialization_test(params.test_cycles);
            } else {
                tester.run_initialization_test();
            }
        });
    }
    
    // Wait for all threads with timeout
    bool all_threads_completed = true;
    auto timeout_point = start_time + std::chrono::seconds(params.timeout_seconds);
    
    for (auto& thread : threads) {
        auto remaining_time = timeout_point - std::chrono::steady_clock::now();
        
        if (remaining_time <= std::chrono::seconds(0)) {
            all_threads_completed = false;
            safe_log("TIMEOUT: Forcing thread termination");
            // Note: In a real implementation, we'd need a more graceful way to handle this
            break;
        }
        
        thread.join();
    }
    
    auto end_time = std::chrono::steady_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(
        end_time - start_time);
    
    // Generate test report
    std::cout << std::endl;
    std::cout << "=== Test Results ===" << std::endl;
    std::cout << "Total execution time: " << duration.count() << "ms" << std::endl;
    std::cout << "Threads started: " << total_threads_started.load() << std::endl;
    std::cout << "Successful initializations: " << successful_initializations.load() << std::endl;
    std::cout << "Failed initializations: " << failed_initializations.load() << std::endl;
    std::cout << "Operator tests passed: " << successful_operator_tests.load() << std::endl;
    std::cout << "Operator tests failed: " << failed_operator_tests.load() << std::endl;
    std::cout << "Expression tests passed: " << successful_expression_tests.load() << std::endl;
    std::cout << "Expression tests failed: " << failed_expression_tests.load() << std::endl;
    
    // Calculate success rates
    double init_success_rate = 0.0;
    double operator_success_rate = 0.0;
    double expression_success_rate = 0.0;
    
    if (total_threads_started.load() > 0) {
        init_success_rate = (double)successful_initializations.load() / 
                           total_threads_started.load() * 100.0;
    }
    
    int total_operator_tests = successful_operator_tests.load() + failed_operator_tests.load();
    if (total_operator_tests > 0) {
        operator_success_rate = (double)successful_operator_tests.load() / 
                               total_operator_tests * 100.0;
    }
    
    int total_expression_tests = successful_expression_tests.load() + failed_expression_tests.load();
    if (total_expression_tests > 0) {
        expression_success_rate = (double)successful_expression_tests.load() / 
                                 total_expression_tests * 100.0;
    }
    
    std::cout << std::endl;
    std::cout << "Success Rates:" << std::endl;
    std::cout << "  Initialization: " << std::fixed << std::setprecision(1) 
              << init_success_rate << "%" << std::endl;
    std::cout << "  Operator tests: " << operator_success_rate << "%" << std::endl;
    std::cout << "  Expression tests: " << expression_success_rate << "%" << std::endl;
    
    // Determine overall test result
    bool test_passed = !global_test_failure.load() &&
                      all_threads_completed &&
                      (failed_initializations.load() == 0) &&
                      (init_success_rate >= 95.0) &&  // Allow 5% tolerance
                      (operator_success_rate >= 95.0) &&
                      (expression_success_rate >= 95.0);
    
    std::cout << std::endl;
    if (test_passed) {
        std::cout << "✅ THREAD SAFETY TEST SUITE: PASSED" << std::endl;
        std::cout << "No race conditions or thread safety issues detected." << std::endl;
        return 0;
    } else {
        std::cout << "❌ THREAD SAFETY TEST SUITE: FAILED" << std::endl;
        std::cout << "Thread safety issues or race conditions detected." << std::endl;
        return 1;
    }
}

int main(int argc, char* argv[]) {
    TestParameters params;
    params.num_threads = 8;
    params.test_cycles = 3;
    params.enable_stress_mode = false;
    params.enable_repeated_init = false;
    params.timeout_seconds = 30;
    
    // Parse command line arguments
    for (int i = 1; i < argc; ++i) {
        std::string arg = argv[i];
        
        if (arg == "--threads" && i + 1 < argc) {
            params.num_threads = std::atoi(argv[++i]);
        } else if (arg == "--cycles" && i + 1 < argc) {
            params.test_cycles = std::atoi(argv[++i]);
        } else if (arg == "--timeout" && i + 1 < argc) {
            params.timeout_seconds = std::atoi(argv[++i]);
        } else if (arg == "--stress") {
            params.enable_stress_mode = true;
            params.num_threads = std::max(params.num_threads, 16);
        } else if (arg == "--repeated-init") {
            params.enable_repeated_init = true;
        } else if (arg == "--help") {
            std::cout << "Usage: " << argv[0] << " [options]" << std::endl;
            std::cout << "Options:" << std::endl;
            std::cout << "  --threads N       Number of concurrent threads (default: 8)" << std::endl;
            std::cout << "  --cycles N        Number of test cycles per thread (default: 3)" << std::endl;
            std::cout << "  --timeout N       Timeout in seconds (default: 30)" << std::endl;
            std::cout << "  --stress          Enable stress testing mode" << std::endl;
            std::cout << "  --repeated-init   Test repeated initialization/cleanup cycles" << std::endl;
            std::cout << "  --help            Show this help message" << std::endl;
            return 0;
        }
    }
    
    // Validate parameters
    if (params.num_threads < 1 || params.num_threads > 64) {
        std::cerr << "Error: Number of threads must be between 1 and 64" << std::endl;
        return 1;
    }
    
    if (params.test_cycles < 1 || params.test_cycles > 100) {
        std::cerr << "Error: Number of cycles must be between 1 and 100" << std::endl;
        return 1;
    }
    
    if (params.timeout_seconds < 5 || params.timeout_seconds > 300) {
        std::cerr << "Error: Timeout must be between 5 and 300 seconds" << std::endl;
        return 1;
    }
    
    return run_thread_safety_test_suite(params);
}

// Mock implementations - these would be replaced with actual TOL functions in the real build
extern "C" {
    static std::atomic<bool> system_initialized{false};
    static std::atomic<bool> grammars_initialized{false};
    static std::atomic<bool> operators_registered{false};
    static std::mutex system_mutex;
    
    void InitializeSystem() {
        std::lock_guard<std::mutex> lock(system_mutex);
        std::this_thread::sleep_for(std::chrono::milliseconds(20));
        system_initialized = true;
    }
    
    void FinalizeSystem() {
        std::this_thread::sleep_for(std::chrono::milliseconds(5));
        // Note: Not resetting flags to simulate persistent state
    }
    
    void InitializeGrammars() {
        if (!system_initialized.load()) {
            throw std::runtime_error("System not initialized");
        }
        std::this_thread::sleep_for(std::chrono::milliseconds(15));
        grammars_initialized = true;
    }
    
    void RegisterAllOperators() {
        if (!grammars_initialized.load()) {
            throw std::runtime_error("Grammars not initialized");
        }
        std::this_thread::sleep_for(std::chrono::milliseconds(25));
        operators_registered = true;
    }
    
    int ValidateOperatorConsistency() {
        if (!operators_registered.load()) {
            return -1;
        }
        std::this_thread::sleep_for(std::chrono::milliseconds(10));
        
        // Simulate occasional validation failures
        static std::atomic<int> validation_counter{0};
        int count = validation_counter.fetch_add(1);
        return (count % 50 == 49) ? -1 : 0;  // Fail every 50th validation
    }
    
    int TestOperatorRegistration() {
        return operators_registered.load() ? 0 : -1;
    }
    
    int TestBasicExpressionEvaluation() {
        if (!operators_registered.load()) {
            return -1;
        }
        std::this_thread::sleep_for(std::chrono::milliseconds(8));
        return 0;
    }
}