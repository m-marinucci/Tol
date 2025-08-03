#include <iostream>
#include <thread>
#include <vector>
#include <atomic>
#include <chrono>
#include <mutex>
#include <random>
#include <cassert>

// TOL headers - adjust paths as needed for your build system
extern "C" {
    // Mock TOL initialization functions for comprehensive testing
    void tol_init();
    int tol_test_basic_operators();
    int tol_test_mathematical_functions();
    int tol_test_matrix_operations();
    void tol_cleanup();
}

// Thread-safe statistics tracking
std::atomic<int> total_threads{0};
std::atomic<int> successful_inits{0};
std::atomic<int> failed_inits{0};
std::atomic<int> operator_test_passes{0};
std::atomic<int> operator_test_failures{0};
std::mutex output_mutex;

void thread_safe_print(const std::string& message) {
    std::lock_guard<std::mutex> lock(output_mutex);
    std::cout << message << std::endl;
}

class ThreadSafetyTester {
private:
    int thread_id;
    std::mt19937 rng;
    
public:
    ThreadSafetyTester(int id) : thread_id(id), rng(id) {}
    
    void run_concurrent_initialization_test() {
        total_threads++;
        
        try {
            // Add random delay to increase chance of race conditions
            std::uniform_int_distribution<int> delay_dist(1, 50);
            std::this_thread::sleep_for(std::chrono::milliseconds(delay_dist(rng)));
            
            thread_safe_print("Thread " + std::to_string(thread_id) + ": Starting TOL initialization");
            
            // Initialize TOL system
            tol_init();
            successful_inits++;
            
            thread_safe_print("Thread " + std::to_string(thread_id) + ": TOL initialization completed");
            
            // Test basic operators
            if (tol_test_basic_operators() == 0) {
                operator_test_passes++;
                thread_safe_print("Thread " + std::to_string(thread_id) + ": Basic operators test PASSED");
            } else {
                operator_test_failures++;
                thread_safe_print("Thread " + std::to_string(thread_id) + ": Basic operators test FAILED");
            }
            
            // Add another random delay
            std::this_thread::sleep_for(std::chrono::milliseconds(delay_dist(rng)));
            
            // Test mathematical functions
            if (tol_test_mathematical_functions() == 0) {
                thread_safe_print("Thread " + std::to_string(thread_id) + ": Mathematical functions test PASSED");
            } else {
                thread_safe_print("Thread " + std::to_string(thread_id) + ": Mathematical functions test FAILED");
            }
            
            // Test matrix operations
            if (tol_test_matrix_operations() == 0) {
                thread_safe_print("Thread " + std::to_string(thread_id) + ": Matrix operations test PASSED");
            } else {
                thread_safe_print("Thread " + std::to_string(thread_id) + ": Matrix operations test FAILED");
            }
            
            // Cleanup for this thread
            tol_cleanup();
            
        } catch (const std::exception& e) {
            failed_inits++;
            thread_safe_print("Thread " + std::to_string(thread_id) + ": Exception caught - " + e.what());
        } catch (...) {
            failed_inits++;
            thread_safe_print("Thread " + std::to_string(thread_id) + ": Unknown exception caught");
        }
    }
    
    void run_stress_test() {
        // Perform multiple initialization/cleanup cycles
        const int cycles = 5;
        
        for (int cycle = 0; cycle < cycles; ++cycle) {
            try {
                std::uniform_int_distribution<int> delay_dist(1, 20);
                std::this_thread::sleep_for(std::chrono::milliseconds(delay_dist(rng)));
                
                tol_init();
                
                // Quick operator test
                tol_test_basic_operators();
                
                tol_cleanup();
                
                thread_safe_print("Thread " + std::to_string(thread_id) + 
                                ": Stress test cycle " + std::to_string(cycle + 1) + " completed");
                
            } catch (...) {
                thread_safe_print("Thread " + std::to_string(thread_id) + 
                                ": Exception in stress test cycle " + std::to_string(cycle + 1));
            }
        }
    }
};

// Test configuration
struct TestConfig {
    int num_threads;
    int test_duration_ms;
    bool enable_stress_test;
    bool enable_verbose_output;
};

int run_thread_safety_tests(const TestConfig& config) {
    std::cout << "=== Multi-threaded TOL Initialization Test ===" << std::endl;
    std::cout << "Configuration:" << std::endl;
    std::cout << "  Number of threads: " << config.num_threads << std::endl;
    std::cout << "  Test duration: " << config.test_duration_ms << "ms" << std::endl;
    std::cout << "  Stress test: " << (config.enable_stress_test ? "enabled" : "disabled") << std::endl;
    std::cout << "================================================" << std::endl;
    
    auto start_time = std::chrono::steady_clock::now();
    
    // Reset statistics
    total_threads = 0;
    successful_inits = 0;
    failed_inits = 0;
    operator_test_passes = 0;
    operator_test_failures = 0;
    
    std::vector<std::thread> threads;
    threads.reserve(config.num_threads);
    
    // Launch threads
    for (int i = 0; i < config.num_threads; ++i) {
        threads.emplace_back([i, &config]() {
            ThreadSafetyTester tester(i);
            
            if (config.enable_stress_test) {
                tester.run_stress_test();
            } else {
                tester.run_concurrent_initialization_test();
            }
        });
    }
    
    // Wait for all threads to complete
    for (auto& thread : threads) {
        thread.join();
    }
    
    auto end_time = std::chrono::steady_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(end_time - start_time);
    
    // Print results
    std::cout << std::endl;
    std::cout << "=== Test Results ===" << std::endl;
    std::cout << "Execution time: " << duration.count() << "ms" << std::endl;
    std::cout << "Total threads: " << total_threads.load() << std::endl;
    std::cout << "Successful initializations: " << successful_inits.load() << std::endl;
    std::cout << "Failed initializations: " << failed_inits.load() << std::endl;
    std::cout << "Operator test passes: " << operator_test_passes.load() << std::endl;
    std::cout << "Operator test failures: " << operator_test_failures.load() << std::endl;
    
    // Calculate success rates
    double init_success_rate = 0.0;
    double operator_success_rate = 0.0;
    
    if (total_threads.load() > 0) {
        init_success_rate = (double)successful_inits.load() / total_threads.load() * 100.0;
    }
    
    int total_operator_tests = operator_test_passes.load() + operator_test_failures.load();
    if (total_operator_tests > 0) {
        operator_success_rate = (double)operator_test_passes.load() / total_operator_tests * 100.0;
    }
    
    std::cout << "Initialization success rate: " << init_success_rate << "%" << std::endl;
    std::cout << "Operator test success rate: " << operator_success_rate << "%" << std::endl;
    
    // Determine overall test result
    bool test_passed = (failed_inits.load() == 0) && 
                      (operator_test_failures.load() == 0) &&
                      (successful_inits.load() >= config.num_threads * 0.95); // Allow 5% tolerance
    
    std::cout << std::endl;
    if (test_passed) {
        std::cout << "✅ THREAD SAFETY TEST PASSED" << std::endl;
        std::cout << "No race conditions or initialization failures detected." << std::endl;
        return 0;
    } else {
        std::cout << "❌ THREAD SAFETY TEST FAILED" << std::endl;
        std::cout << "Race conditions or initialization failures detected." << std::endl;
        return 1;
    }
}

int main(int argc, char* argv[]) {
    TestConfig config;
    config.num_threads = 16;  // Default to 16 threads
    config.test_duration_ms = 5000;  // 5 seconds
    config.enable_stress_test = false;
    config.enable_verbose_output = true;
    
    // Parse command line arguments
    for (int i = 1; i < argc; ++i) {
        std::string arg = argv[i];
        
        if (arg == "--threads" && i + 1 < argc) {
            config.num_threads = std::atoi(argv[++i]);
        } else if (arg == "--duration" && i + 1 < argc) {
            config.test_duration_ms = std::atoi(argv[++i]);
        } else if (arg == "--stress") {
            config.enable_stress_test = true;
        } else if (arg == "--quiet") {
            config.enable_verbose_output = false;
        } else if (arg == "--help") {
            std::cout << "Usage: " << argv[0] << " [options]" << std::endl;
            std::cout << "Options:" << std::endl;
            std::cout << "  --threads N     Number of threads (default: 16)" << std::endl;
            std::cout << "  --duration N    Test duration in milliseconds (default: 5000)" << std::endl;
            std::cout << "  --stress        Enable stress testing mode" << std::endl;
            std::cout << "  --quiet         Reduce output verbosity" << std::endl;
            std::cout << "  --help          Show this help message" << std::endl;
            return 0;
        }
    }
    
    // Validate configuration
    if (config.num_threads < 1 || config.num_threads > 100) {
        std::cerr << "Error: Number of threads must be between 1 and 100" << std::endl;
        return 1;
    }
    
    if (config.test_duration_ms < 1000 || config.test_duration_ms > 60000) {
        std::cerr << "Error: Test duration must be between 1000 and 60000 milliseconds" << std::endl;
        return 1;
    }
    
    return run_thread_safety_tests(config);
}

// Mock implementations for testing
extern "C" {
    static std::atomic<bool> tol_initialized{false};
    static std::mutex init_mutex;
    
    void tol_init() {
        std::lock_guard<std::mutex> lock(init_mutex);
        
        // Simulate initialization work
        std::this_thread::sleep_for(std::chrono::milliseconds(10));
        
        if (!tol_initialized.load()) {
            tol_initialized = true;
        }
    }
    
    int tol_test_basic_operators() {
        if (!tol_initialized.load()) {
            return -1; // Not initialized
        }
        
        // Simulate basic operator testing
        std::this_thread::sleep_for(std::chrono::milliseconds(5));
        
        // Simulate occasional failures to test error handling
        static std::atomic<int> test_counter{0};
        int count = test_counter.fetch_add(1);
        
        // Fail every 100th test to simulate rare race conditions
        return (count % 100 == 99) ? -1 : 0;
    }
    
    int tol_test_mathematical_functions() {
        if (!tol_initialized.load()) {
            return -1;
        }
        
        std::this_thread::sleep_for(std::chrono::milliseconds(3));
        return 0; // Always succeed for this test
    }
    
    int tol_test_matrix_operations() {
        if (!tol_initialized.load()) {
            return -1;
        }
        
        std::this_thread::sleep_for(std::chrono::milliseconds(7));
        return 0; // Always succeed for this test
    }
    
void tol_cleanup() {
    // Simulate cleanup work
    std::this_thread::sleep_for(std::chrono::milliseconds(2));
    // Note: We don't reset tol_initialized here to simulate persistent state
}

// Test: Re-initialization after cleanup should not reset tol_initialized
void test_reinitialization_after_cleanup() {
    // Ensure tol_initialized is true (simulate initialized state)
    tol_initialized.store(true);

    // Call cleanup
    tol_cleanup();

    // tol_initialized should still be true
    assert(tol_initialized.load() && "tol_initialized should remain true after cleanup");

    // Try to re-initialize (simulate what would happen in real code)
    int init_result = tol_initialize();
    // If tol_initialize is a no-op when already initialized, it should return 0 or a specific value
    assert(init_result == 0 && "Re-initialization should succeed or be a no-op");

    // Cleanup again for completeness
    tol_cleanup();
}

// Register the test (assuming a simple test runner)
struct RegisterReinitTest {
    RegisterReinitTest() {
        test_reinitialization_after_cleanup();
    }
} registerReinitTestInstance;
}