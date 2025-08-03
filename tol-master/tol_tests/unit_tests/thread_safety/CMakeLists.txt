# Thread Safety Tests for TOL
cmake_minimum_required(VERSION 3.10)

# Find required packages
find_package(Threads REQUIRED)

# Compiler requirements for thread safety testing
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Thread safety test executable
add_executable(multi_threaded_init_test multi_threaded_init_test.cpp)

# Link threading library
target_link_libraries(multi_threaded_init_test PRIVATE Threads::Threads)

# Compiler flags for thread safety
if(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
    target_compile_options(multi_threaded_init_test PRIVATE
        -Wall
        -Wextra
        -pthread
        -fno-omit-frame-pointer
        $<$<CONFIG:Debug>:-g -O0>
        $<$<CONFIG:Release>:-O2 -DNDEBUG>
    )
    
    target_link_options(multi_threaded_init_test PRIVATE
        -pthread
    )
endif()

# ThreadSanitizer build option
option(ENABLE_THREAD_SANITIZER "Enable ThreadSanitizer for thread safety testing" OFF)
if(ENABLE_THREAD_SANITIZER)
    if(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
        target_compile_options(multi_threaded_init_test PRIVATE -fsanitize=thread)
        target_link_options(multi_threaded_init_test PRIVATE -fsanitize=thread)
        message(STATUS "ThreadSanitizer enabled for thread safety tests")
    else()
        message(WARNING "ThreadSanitizer is not supported with this compiler")
    endif()
endif()

# AddressSanitizer build option
option(ENABLE_ADDRESS_SANITIZER "Enable AddressSanitizer for memory safety testing" OFF)
if(ENABLE_ADDRESS_SANITIZER)
    if(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
        target_compile_options(multi_threaded_init_test PRIVATE -fsanitize=address)
        target_link_options(multi_threaded_init_test PRIVATE -fsanitize=address)
        message(STATUS "AddressSanitizer enabled for thread safety tests")
    else()
        message(WARNING "AddressSanitizer is not supported with this compiler")
    endif()
endif()

# UndefinedBehaviorSanitizer build option
option(ENABLE_UNDEFINED_SANITIZER "Enable UndefinedBehaviorSanitizer" OFF)
if(ENABLE_UNDEFINED_SANITIZER)
    if(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
        target_compile_options(multi_threaded_init_test PRIVATE -fsanitize=undefined)
        target_link_options(multi_threaded_init_test PRIVATE -fsanitize=undefined)
        message(STATUS "UndefinedBehaviorSanitizer enabled for thread safety tests")
    else()
        message(WARNING "UndefinedBehaviorSanitizer is not supported with this compiler")
    endif()
endif()

# Add test to CTest if testing is enabled
if(ENABLE_TESTING)
    enable_testing()
    
    # Standard thread safety test
    add_test(
        NAME thread_safety_basic
        COMMAND multi_threaded_init_test --threads 8 --duration 3000
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    )
    
    # High concurrency test
    add_test(
        NAME thread_safety_high_concurrency
        COMMAND multi_threaded_init_test --threads 32 --duration 5000
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    )
    
    # Stress test
    add_test(
        NAME thread_safety_stress
        COMMAND multi_threaded_init_test --threads 16 --stress --duration 10000
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    )
    
    # Set test properties
    set_tests_properties(
        thread_safety_basic
        thread_safety_high_concurrency
        thread_safety_stress
        PROPERTIES
            TIMEOUT 30
            LABELS "thread_safety;concurrency"
    )
    
    # ThreadSanitizer specific test (if enabled)
    if(ENABLE_THREAD_SANITIZER)
        add_test(
            NAME thread_safety_tsan
            COMMAND multi_threaded_init_test --threads 8 --duration 2000
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        )
        
        set_tests_properties(thread_safety_tsan PROPERTIES
            TIMEOUT 60
            LABELS "thread_safety;sanitizer;tsan"
            ENVIRONMENT "TSAN_OPTIONS=abort_on_error=1:halt_on_error=1"
        )
    endif()
    
    # AddressSanitizer specific test (if enabled)
    if(ENABLE_ADDRESS_SANITIZER)
        add_test(
            NAME thread_safety_asan
            COMMAND multi_threaded_init_test --threads 4 --duration 2000
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        )
        
        set_tests_properties(thread_safety_asan PROPERTIES
            TIMEOUT 60
            LABELS "thread_safety;sanitizer;asan"
            ENVIRONMENT "ASAN_OPTIONS=abort_on_error=1:detect_leaks=1"
        )
    endif()
    
    message(STATUS "Thread safety tests configured")
endif()

# Installation
install(TARGETS multi_threaded_init_test
    RUNTIME DESTINATION bin/tests
    COMPONENT Testing
)

# Add custom targets for convenience
add_custom_target(test_thread_safety
    COMMAND multi_threaded_init_test --threads 16 --duration 5000
    DEPENDS multi_threaded_init_test
    COMMENT "Running thread safety tests"
)

add_custom_target(test_thread_safety_stress
    COMMAND multi_threaded_init_test --threads 32 --stress --duration 10000
    DEPENDS multi_threaded_init_test
    COMMENT "Running thread safety stress tests"
)

# Help target
add_custom_target(help_thread_safety
    COMMAND multi_threaded_init_test --help
    DEPENDS multi_threaded_init_test
    COMMENT "Show thread safety test help"
)