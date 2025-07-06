cmake_minimum_required(VERSION 3.16)
project(TOL_Comprehensive_Testing_Framework VERSION 1.0.0 LANGUAGES NONE)

#############################################################################
# TOL Comprehensive Cross-Platform Testing Framework
# Issue: NUM-11 - P0: Comprehensive Cross-Platform Testing Framework
# Author: Massimiliano Marinucci
# Date: 2025-07-06
#############################################################################

# Set CMake policies
cmake_policy(SET CMP0057 NEW)  # Support for IN_LIST operator

# Add custom CMake modules path
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

# Enable testing
enable_testing()

# Find TOL interpreter
find_package(TOL REQUIRED)

# Configuration options
option(TOL_TESTS_ENABLE_PERFORMANCE "Enable performance tests" ON)
option(TOL_TESTS_ENABLE_MEMORY "Enable memory tests" ON)
option(TOL_TESTS_ENABLE_INTEGRATION "Enable integration tests" ON)
option(TOL_TESTS_ENABLE_PLATFORM "Enable platform-specific tests" ON)
option(TOL_TESTS_PARALLEL "Enable parallel test execution" ON)
option(TOL_TESTS_GENERATE_REPORTS "Generate detailed test reports" ON)

# Set test timeout values (in seconds)
set(TOL_TESTS_UNIT_TIMEOUT 300 CACHE STRING "Timeout for unit tests")
set(TOL_TESTS_INTEGRATION_TIMEOUT 600 CACHE STRING "Timeout for integration tests")
set(TOL_TESTS_PERFORMANCE_TIMEOUT 1200 CACHE STRING "Timeout for performance tests")
set(TOL_TESTS_MEMORY_TIMEOUT 600 CACHE STRING "Timeout for memory tests")

# Platform detection
if(WIN32)
    set(TOL_PLATFORM "Windows")
    set(TOL_PLATFORM_ID "WINDOWS")
elseif(APPLE)
    set(TOL_PLATFORM "macOS")
    set(TOL_PLATFORM_ID "MACOS")
elseif(UNIX)
    set(TOL_PLATFORM "Linux")
    set(TOL_PLATFORM_ID "LINUX")
else()
    set(TOL_PLATFORM "Unknown")
    set(TOL_PLATFORM_ID "UNKNOWN")
endif()

message(STATUS "TOL Testing Framework Configuration:")
message(STATUS "  Platform: ${TOL_PLATFORM}")
message(STATUS "  TOL Binary: ${TOL_EXECUTABLE}")
message(STATUS "  Performance Tests: ${TOL_TESTS_ENABLE_PERFORMANCE}")
message(STATUS "  Memory Tests: ${TOL_TESTS_ENABLE_MEMORY}")
message(STATUS "  Integration Tests: ${TOL_TESTS_ENABLE_INTEGRATION}")
message(STATUS "  Platform Tests: ${TOL_TESTS_ENABLE_PLATFORM}")
message(STATUS "  Parallel Execution: ${TOL_TESTS_PARALLEL}")

# Create output directories
set(TOL_TESTS_OUTPUT_DIR "${CMAKE_BINARY_DIR}/test_results")
set(TOL_TESTS_REPORTS_DIR "${TOL_TESTS_OUTPUT_DIR}/reports")
set(TOL_TESTS_LOGS_DIR "${TOL_TESTS_OUTPUT_DIR}/logs")

file(MAKE_DIRECTORY ${TOL_TESTS_OUTPUT_DIR})
file(MAKE_DIRECTORY ${TOL_TESTS_REPORTS_DIR})
file(MAKE_DIRECTORY ${TOL_TESTS_LOGS_DIR})

# Function to add TOL test
function(add_tol_test)
    set(options PERFORMANCE MEMORY INTEGRATION PLATFORM)
    set(oneValueArgs NAME CATEGORY TIMEOUT WORKING_DIRECTORY)
    set(multiValueArgs FILES DEPENDS LABELS)
    cmake_parse_arguments(TEST "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if(NOT TEST_NAME)
        message(FATAL_ERROR "add_tol_test: NAME is required")
    endif()

    if(NOT TEST_FILES)
        message(FATAL_ERROR "add_tol_test: FILES is required")
    endif()

    # Set default timeout based on category
    if(NOT TEST_TIMEOUT)
        if(TEST_PERFORMANCE)
            set(TEST_TIMEOUT ${TOL_TESTS_PERFORMANCE_TIMEOUT})
        elseif(TEST_MEMORY)
            set(TEST_TIMEOUT ${TOL_TESTS_MEMORY_TIMEOUT})
        elseif(TEST_INTEGRATION)
            set(TEST_TIMEOUT ${TOL_TESTS_INTEGRATION_TIMEOUT})
        else()
            set(TEST_TIMEOUT ${TOL_TESTS_UNIT_TIMEOUT})
        endif()
    endif()

    # Set working directory
    if(NOT TEST_WORKING_DIRECTORY)
        set(TEST_WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}")
    endif()

    # Create test command
    set(TEST_COMMAND ${TOL_EXECUTABLE} -v ${TEST_FILES})
    
    # Add the test
    add_test(
        NAME ${TEST_NAME}
        COMMAND ${TEST_COMMAND}
        WORKING_DIRECTORY ${TEST_WORKING_DIRECTORY}
    )

    # Set test properties
    set_tests_properties(${TEST_NAME} PROPERTIES
        TIMEOUT ${TEST_TIMEOUT}
        LABELS "${TEST_CATEGORY};${TOL_PLATFORM_ID}"
    )

    # Add custom labels
    if(TEST_LABELS)
        set_tests_properties(${TEST_NAME} PROPERTIES
            LABELS "${TEST_CATEGORY};${TOL_PLATFORM_ID};${TEST_LABELS}"
        )
    endif()

    # Add dependencies
    if(TEST_DEPENDS)
        set_tests_properties(${TEST_NAME} PROPERTIES
            DEPENDS "${TEST_DEPENDS}"
        )
    endif()

    # Set environment variables
    set_tests_properties(${TEST_NAME} PROPERTIES
        ENVIRONMENT "TOL_TEST_PLATFORM=${TOL_PLATFORM_ID};TOL_TEST_OUTPUT_DIR=${TOL_TESTS_OUTPUT_DIR}"
    )

    message(STATUS "Added test: ${TEST_NAME} (${TEST_CATEGORY}, timeout: ${TEST_TIMEOUT}s)")
endfunction()

# Function to discover and add tests from directory
function(discover_tol_tests DIRECTORY CATEGORY)
    file(GLOB_RECURSE TEST_FILES "${DIRECTORY}/*/test.tol")
    
    foreach(TEST_FILE ${TEST_FILES})
        get_filename_component(TEST_DIR ${TEST_FILE} DIRECTORY)
        get_filename_component(TEST_NAME ${TEST_DIR} NAME)
        
        set(FULL_TEST_NAME "${CATEGORY}_${TEST_NAME}")
        
        # Determine test type flags
        set(TEST_FLAGS "")
        if(CATEGORY STREQUAL "performance")
            set(TEST_FLAGS "PERFORMANCE")
        elseif(CATEGORY STREQUAL "memory")
            set(TEST_FLAGS "MEMORY")
        elseif(CATEGORY STREQUAL "integration")
            set(TEST_FLAGS "INTEGRATION")
        elseif(CATEGORY STREQUAL "platform")
            set(TEST_FLAGS "PLATFORM")
        endif()
        
        add_tol_test(
            NAME ${FULL_TEST_NAME}
            CATEGORY ${CATEGORY}
            FILES ${TEST_FILE}
            WORKING_DIRECTORY ${TEST_DIR}
            ${TEST_FLAGS}
        )
    endforeach()
endfunction()

# Discover and add unit tests
discover_tol_tests("${CMAKE_CURRENT_SOURCE_DIR}/unit_tests" "unit")

# Conditionally add other test categories
if(TOL_TESTS_ENABLE_INTEGRATION)
    discover_tol_tests("${CMAKE_CURRENT_SOURCE_DIR}/integration_tests" "integration")
endif()

if(TOL_TESTS_ENABLE_PERFORMANCE)
    discover_tol_tests("${CMAKE_CURRENT_SOURCE_DIR}/performance_tests" "performance")
endif()

if(TOL_TESTS_ENABLE_MEMORY)
    discover_tol_tests("${CMAKE_CURRENT_SOURCE_DIR}/memory_tests" "memory")
endif()

if(TOL_TESTS_ENABLE_PLATFORM)
    discover_tol_tests("${CMAKE_CURRENT_SOURCE_DIR}/platform_tests" "platform")
endif()

# Add comprehensive test runner
add_tol_test(
    NAME comprehensive_test_runner
    CATEGORY comprehensive
    FILES "${CMAKE_CURRENT_SOURCE_DIR}/enhanced_test_runner.tol"
    TIMEOUT 3600
    LABELS "comprehensive;full_suite"
)

# Add custom targets for different test categories
add_custom_target(test_unit
    COMMAND ${CMAKE_CTEST_COMMAND} -L "unit" --output-on-failure
    COMMENT "Running unit tests"
)

if(TOL_TESTS_ENABLE_INTEGRATION)
    add_custom_target(test_integration
        COMMAND ${CMAKE_CTEST_COMMAND} -L "integration" --output-on-failure
        COMMENT "Running integration tests"
    )
endif()

if(TOL_TESTS_ENABLE_PERFORMANCE)
    add_custom_target(test_performance
        COMMAND ${CMAKE_CTEST_COMMAND} -L "performance" --output-on-failure
        COMMENT "Running performance tests"
    )
endif()

if(TOL_TESTS_ENABLE_MEMORY)
    add_custom_target(test_memory
        COMMAND ${CMAKE_CTEST_COMMAND} -L "memory" --output-on-failure
        COMMENT "Running memory tests"
    )
endif()

if(TOL_TESTS_ENABLE_PLATFORM)
    add_custom_target(test_platform
        COMMAND ${CMAKE_CTEST_COMMAND} -L "platform" --output-on-failure
        COMMENT "Running platform-specific tests"
    )
endif()

# Add comprehensive test target
add_custom_target(test_comprehensive
    COMMAND ${CMAKE_CTEST_COMMAND} -L "comprehensive" --output-on-failure
    COMMENT "Running comprehensive test suite"
)

# Add parallel test execution target
if(TOL_TESTS_PARALLEL)
    add_custom_target(test_parallel
        COMMAND ${CMAKE_CTEST_COMMAND} --parallel ${CMAKE_BUILD_PARALLEL_LEVEL} --output-on-failure
        COMMENT "Running all tests in parallel"
    )
endif()

# Generate test reports if enabled
if(TOL_TESTS_GENERATE_REPORTS)
    find_program(PYTHON_EXECUTABLE python3 python)
    if(PYTHON_EXECUTABLE)
        add_custom_target(test_reports
            COMMAND ${PYTHON_EXECUTABLE} "${CMAKE_CURRENT_SOURCE_DIR}/scripts/generate_reports.py" 
                    --input "${TOL_TESTS_OUTPUT_DIR}" 
                    --output "${TOL_TESTS_REPORTS_DIR}"
            COMMENT "Generating test reports"
        )
    endif()
endif()

# Print summary
message(STATUS "TOL Testing Framework configured successfully")
message(STATUS "Use 'make test' or 'ctest' to run all tests")
message(STATUS "Use 'make test_unit' to run unit tests only")
message(STATUS "Use 'make test_comprehensive' to run the full test suite")
if(TOL_TESTS_PARALLEL)
    message(STATUS "Use 'make test_parallel' to run tests in parallel")
endif()
if(TOL_TESTS_GENERATE_REPORTS)
    message(STATUS "Use 'make test_reports' to generate detailed reports")
endif()
