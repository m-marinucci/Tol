# CTest Configuration for TOL Project
# This file configures CTest dashboard submission and reporting

set(CTEST_PROJECT_NAME "TOL")
set(CTEST_NIGHTLY_START_TIME "00:00:00 EST")

# Dashboard submission configuration
set(CTEST_DROP_METHOD "http")
set(CTEST_DROP_SITE "my.cdash.org")
set(CTEST_DROP_LOCATION "/submit.php?project=TOL")
set(CTEST_DROP_SITE_CDASH TRUE)

# Test configuration
set(CTEST_TEST_TIMEOUT 300)
set(CTEST_OUTPUT_ON_FAILURE ON)

# Coverage configuration
set(CTEST_COVERAGE_COMMAND "/usr/bin/gcov")

# Memory checking configuration
set(CTEST_MEMORYCHECK_COMMAND "MEMORYCHECK_COMMAND-NOTFOUND")
set(CTEST_MEMORYCHECK_COMMAND_OPTIONS "--trace-children=yes --leak-check=full")
set(CTEST_MEMORYCHECK_SUPPRESSIONS_FILE "/mnt/persist/workspace/tol-master/tol/cmake/valgrind.supp")

# Build configuration
set(CTEST_CMAKE_GENERATOR "Unix Makefiles")
set(CTEST_BUILD_CONFIGURATION "")

# Source and binary directories
set(CTEST_SOURCE_DIRECTORY "/mnt/persist/workspace/tol-master/tol")
set(CTEST_BINARY_DIRECTORY "/mnt/persist/workspace/tol-master/tol/test_build")

# Custom test labels
set(CTEST_CUSTOM_TESTS_IGNORE
    # Add any tests to ignore here
)

# Custom warning exceptions
set(CTEST_CUSTOM_WARNING_EXCEPTION
    "warning: unused parameter"
    "warning: unused variable"
)

# Custom error exceptions
set(CTEST_CUSTOM_ERROR_EXCEPTION
    # Add any error patterns to ignore here
)

# Maximum number of warnings/errors to report
set(CTEST_CUSTOM_MAXIMUM_NUMBER_OF_WARNINGS 50)
set(CTEST_CUSTOM_MAXIMUM_NUMBER_OF_ERRORS 10)

# Test result formatting
set(CTEST_CUSTOM_POST_TEST
    # Custom post-test commands can be added here
)
