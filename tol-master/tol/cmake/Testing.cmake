# TOL Testing Configuration
# This file configures CTest integration for the TOL project

# Enable testing if requested
option(ENABLE_TESTING "Enable testing with CTest" OFF)

if(ENABLE_TESTING)
    enable_testing()
    include(CTest)
    
    message(STATUS "Testing enabled - CTest integration active")
    
    # Set test timeout (in seconds)
    set(CTEST_TEST_TIMEOUT 300)
    
    # Configure test output
    set(CTEST_OUTPUT_ON_FAILURE ON)
    
    # Coverage configuration
    option(COVERAGE_ENABLED "Enable code coverage analysis" OFF)
    
    if(COVERAGE_ENABLED AND CMAKE_COMPILER_IS_GNUCXX)
        message(STATUS "Code coverage enabled")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --coverage -fprofile-arcs -ftest-coverage")
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} --coverage -fprofile-arcs -ftest-coverage")
        set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} --coverage")
        
        # Find lcov for coverage reporting
        find_program(LCOV_PATH lcov)
        find_program(GENHTML_PATH genhtml)
        
        if(LCOV_PATH AND GENHTML_PATH)
            message(STATUS "lcov found: ${LCOV_PATH}")
            message(STATUS "genhtml found: ${GENHTML_PATH}")
            
            # Add coverage target
            add_custom_target(coverage
                COMMAND ${LCOV_PATH} --directory . --capture --output-file coverage.info
                COMMAND ${LCOV_PATH} --remove coverage.info '/usr/*' --output-file coverage.info
                COMMAND ${GENHTML_PATH} coverage.info --output-directory coverage_html
                WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
                COMMENT "Generating code coverage report"
            )
        endif()
    endif()
    
    # Function to add TOL tests
    function(add_tol_test TEST_NAME TEST_SCRIPT)
        set(TEST_WORKING_DIR "${CMAKE_SOURCE_DIR}/../tol_tests")
        
        # Check if test script exists
        if(EXISTS "${TEST_WORKING_DIR}/${TEST_SCRIPT}")
            add_test(
                NAME ${TEST_NAME}
                COMMAND ${CMAKE_BINARY_DIR}/bin/tolcon -v ${TEST_SCRIPT}
                WORKING_DIRECTORY ${TEST_WORKING_DIR}
            )
            
            # Set test properties
            set_tests_properties(${TEST_NAME} PROPERTIES
                TIMEOUT ${CTEST_TEST_TIMEOUT}
                ENVIRONMENT "TOL_BIN_PATH=${CMAKE_BINARY_DIR}/bin"
            )
            
            message(STATUS "Added test: ${TEST_NAME} -> ${TEST_SCRIPT}")
        else()
            message(WARNING "Test script not found: ${TEST_WORKING_DIR}/${TEST_SCRIPT}")
        endif()
    endfunction()
    
    # Function to add unit tests for specific modules
    function(add_module_unit_test MODULE_NAME)
        set(TEST_NAME "unit_${MODULE_NAME}")
        set(TEST_EXECUTABLE "${CMAKE_BINARY_DIR}/bin/test_${MODULE_NAME}")
        
        if(TARGET test_${MODULE_NAME})
            add_test(
                NAME ${TEST_NAME}
                COMMAND ${TEST_EXECUTABLE}
            )
            
            set_tests_properties(${TEST_NAME} PROPERTIES
                TIMEOUT 60
                LABELS "unit"
            )
            
            message(STATUS "Added unit test: ${TEST_NAME}")
        endif()
    endfunction()
    
    # Function to add performance benchmarks
    function(add_performance_test TEST_NAME TEST_COMMAND)
        add_test(
            NAME "perf_${TEST_NAME}"
            COMMAND ${TEST_COMMAND}
        )
        
        set_tests_properties("perf_${TEST_NAME}" PROPERTIES
            TIMEOUT 600
            LABELS "performance"
        )
        
        message(STATUS "Added performance test: perf_${TEST_NAME}")
    endfunction()
    
    # Function to add memory leak tests
    function(add_valgrind_test TEST_NAME TEST_COMMAND)
        find_program(VALGRIND_PATH valgrind)
        
        if(VALGRIND_PATH)
            add_test(
                NAME "valgrind_${TEST_NAME}"
                COMMAND ${VALGRIND_PATH} 
                    --tool=memcheck 
                    --leak-check=full 
                    --error-exitcode=1
                    --suppressions=${CMAKE_SOURCE_DIR}/cmake/valgrind.supp
                    ${TEST_COMMAND}
            )
            
            set_tests_properties("valgrind_${TEST_NAME}" PROPERTIES
                TIMEOUT 900
                LABELS "memory"
            )
            
            message(STATUS "Added Valgrind test: valgrind_${TEST_NAME}")
        endif()
    endfunction()
    
    # Configure test discovery and registration
    function(discover_and_register_tests)
        message(STATUS "Discovering TOL tests...")
        
        # Core TOL tests
        add_tol_test("tol_core_tests" "tol/_tolTester.tol")
        add_tol_test("tol_bsr_tests" "tol/_bsrTester.tol")
        add_tol_test("tol_known_bugs" "tol/_tolTester_knownbugs.tol")
        
        # TolTcl tests (if available)
        add_tol_test("toltcl_tests" "toltcl/_toltclTester.tol")
        
        # Database tests (if available)
        add_tol_test("toldb_tests" "toldb/_tolTester.tol")
        
        # Add basic functionality tests
        if(TARGET tolcon)
            add_test(
                NAME "basic_version_test"
                COMMAND ${CMAKE_BINARY_DIR}/bin/tolcon --version
            )
            
            add_test(
                NAME "basic_help_test"
                COMMAND ${CMAKE_BINARY_DIR}/bin/tolcon --help
            )
            
            set_tests_properties("basic_version_test" "basic_help_test" PROPERTIES
                TIMEOUT 30
                LABELS "basic"
            )
        endif()
        
        # Add performance benchmarks
        if(TARGET tolcon)
            add_performance_test("arithmetic_performance"
                "${CMAKE_BINARY_DIR}/bin/tolcon -c \"Real x = 0; For(Real i=1, i<=100000, i++, x = x + i*i); WriteLn(x)\""
            )
        endif()
        
        # Add memory leak tests for key executables
        if(TARGET tolcon)
            add_valgrind_test("tolcon_memory"
                "${CMAKE_BINARY_DIR}/bin/tolcon --version"
            )
        endif()
        
        message(STATUS "Test discovery completed")
    endfunction()
    
    # Custom test targets
    add_custom_target(test_all
        COMMAND ${CMAKE_CTEST_COMMAND} --output-on-failure
        DEPENDS tolcon
        COMMENT "Running all TOL tests"
    )
    
    add_custom_target(test_unit
        COMMAND ${CMAKE_CTEST_COMMAND} --output-on-failure -L unit
        DEPENDS tolcon
        COMMENT "Running unit tests only"
    )
    
    add_custom_target(test_performance
        COMMAND ${CMAKE_CTEST_COMMAND} --output-on-failure -L performance
        DEPENDS tolcon
        COMMENT "Running performance tests only"
    )
    
    add_custom_target(test_memory
        COMMAND ${CMAKE_CTEST_COMMAND} --output-on-failure -L memory
        DEPENDS tolcon
        COMMENT "Running memory leak tests"
    )
    
    # Test reporting configuration
    configure_file(
        "${CMAKE_CURRENT_LIST_DIR}/CTestConfig.cmake.in"
        "${CMAKE_BINARY_DIR}/CTestConfig.cmake"
        @ONLY
    )
    
endif(ENABLE_TESTING)
