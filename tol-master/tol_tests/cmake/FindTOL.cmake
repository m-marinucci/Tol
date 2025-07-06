#############################################################################
# FindTOL.cmake - CMake module to find TOL interpreter
# Issue: NUM-11 - P0: Comprehensive Cross-Platform Testing Framework
# Author: Massimiliano Marinucci
# Date: 2025-07-06
#############################################################################

#[=======================================================================[.rst:
FindTOL
-------

Find the TOL (Tree of Life) interpreter.

This module finds the TOL interpreter and defines the following variables:

``TOL_FOUND``
  True if the TOL interpreter was found.
``TOL_EXECUTABLE``
  Path to the TOL interpreter executable.
``TOL_VERSION``
  Version of the TOL interpreter (if available).
``TOL_PLATFORM_ID``
  Platform identifier for TOL.

The following cache variables may also be set:

``TOL_EXECUTABLE``
  Path to the TOL interpreter executable.

Example usage:

.. code-block:: cmake

  find_package(TOL REQUIRED)
  if(TOL_FOUND)
    message(STATUS "Found TOL: ${TOL_EXECUTABLE}")
  endif()

#]=======================================================================]

# Platform-specific executable names and search paths
if(WIN32)
    set(TOL_EXECUTABLE_NAMES tolsh.exe tolcon.exe tol.exe)
    set(TOL_SEARCH_PATHS
        "C:/Program Files/TOL"
        "C:/Program Files (x86)/TOL"
        "C:/TOL"
        "${CMAKE_SOURCE_DIR}/../windows/ActiveTol/bin"
        "${CMAKE_SOURCE_DIR}/windows/ActiveTol/bin"
        "$ENV{PROGRAMFILES}/TOL"
        "$ENV{PROGRAMFILES(X86)}/TOL"
    )
elseif(APPLE)
    set(TOL_EXECUTABLE_NAMES tolcon tol tolsh)
    set(TOL_SEARCH_PATHS
        "/usr/local/tol/bin"
        "/usr/local/bin"
        "/opt/tol/bin"
        "/opt/local/bin"
        "/Applications/TOL.app/Contents/MacOS"
        "${CMAKE_SOURCE_DIR}/../macos/tol/bin"
        "${CMAKE_SOURCE_DIR}/macos/tol/bin"
        "$ENV{HOME}/tol/bin"
    )
else() # Linux and other Unix-like systems
    set(TOL_EXECUTABLE_NAMES tolcon tol tolsh)
    set(TOL_SEARCH_PATHS
        "/usr/local/tol-gcc-release/bin"
        "/usr/local/tol/bin"
        "/usr/local/bin"
        "/usr/bin"
        "/opt/tol/bin"
        "${CMAKE_SOURCE_DIR}/../tol/bin"
        "${CMAKE_SOURCE_DIR}/tol/bin"
        "$ENV{HOME}/tol/bin"
    )
endif()

# Search for TOL executable
find_program(TOL_EXECUTABLE
    NAMES ${TOL_EXECUTABLE_NAMES}
    PATHS ${TOL_SEARCH_PATHS}
    PATH_SUFFIXES bin
    DOC "Path to the TOL interpreter"
)

# Try to determine TOL version
if(TOL_EXECUTABLE)
    # Try to get version information
    execute_process(
        COMMAND ${TOL_EXECUTABLE} --version
        OUTPUT_VARIABLE TOL_VERSION_OUTPUT
        ERROR_VARIABLE TOL_VERSION_ERROR
        RESULT_VARIABLE TOL_VERSION_RESULT
        OUTPUT_STRIP_TRAILING_WHITESPACE
        ERROR_STRIP_TRAILING_WHITESPACE
    )
    
    if(TOL_VERSION_RESULT EQUAL 0)
        # Parse version from output
        string(REGEX MATCH "[0-9]+\\.[0-9]+\\.[0-9]+" TOL_VERSION "${TOL_VERSION_OUTPUT}")
    else()
        # Try alternative method - run a simple TOL command
        execute_process(
            COMMAND ${TOL_EXECUTABLE} -c "WriteLn(\"TOL_VERSION_CHECK\")"
            OUTPUT_VARIABLE TOL_TEST_OUTPUT
            ERROR_VARIABLE TOL_TEST_ERROR
            RESULT_VARIABLE TOL_TEST_RESULT
            OUTPUT_STRIP_TRAILING_WHITESPACE
            ERROR_STRIP_TRAILING_WHITESPACE
        )
        
        if(TOL_TEST_RESULT EQUAL 0)
            set(TOL_VERSION "Unknown")
        else()
            set(TOL_VERSION "")
        endif()
    endif()
endif()

# Determine platform ID for TOL
if(WIN32)
    if(CMAKE_SIZEOF_VOID_P EQUAL 8)
        set(TOL_PLATFORM_ID "Windows_x86_64")
    else()
        set(TOL_PLATFORM_ID "Windows_x86_32")
    endif()
elseif(APPLE)
    if(CMAKE_SIZEOF_VOID_P EQUAL 8)
        set(TOL_PLATFORM_ID "macOS_x86_64")
    else()
        set(TOL_PLATFORM_ID "macOS_x86_32")
    endif()
else() # Linux and other Unix-like systems
    if(CMAKE_SIZEOF_VOID_P EQUAL 8)
        set(TOL_PLATFORM_ID "Linux_x86_64")
    else()
        set(TOL_PLATFORM_ID "Linux_x86_32")
    endif()
endif()

# Validate TOL executable
if(TOL_EXECUTABLE)
    # Test if TOL executable works
    execute_process(
        COMMAND ${TOL_EXECUTABLE} -c "WriteLn(\"TOL_TEST_SUCCESS\")"
        OUTPUT_VARIABLE TOL_VALIDATION_OUTPUT
        ERROR_VARIABLE TOL_VALIDATION_ERROR
        RESULT_VARIABLE TOL_VALIDATION_RESULT
        OUTPUT_STRIP_TRAILING_WHITESPACE
        ERROR_STRIP_TRAILING_WHITESPACE
    )
    
    if(TOL_VALIDATION_RESULT EQUAL 0 AND TOL_VALIDATION_OUTPUT MATCHES "TOL_TEST_SUCCESS")
        set(TOL_EXECUTABLE_VALID TRUE)
    else()
        set(TOL_EXECUTABLE_VALID FALSE)
        message(WARNING "TOL executable found but validation failed: ${TOL_EXECUTABLE}")
        message(WARNING "Validation error: ${TOL_VALIDATION_ERROR}")
    endif()
else()
    set(TOL_EXECUTABLE_VALID FALSE)
endif()

# Handle QUIET and REQUIRED arguments
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(TOL
    FOUND_VAR TOL_FOUND
    REQUIRED_VARS TOL_EXECUTABLE TOL_EXECUTABLE_VALID
    VERSION_VAR TOL_VERSION
    FAIL_MESSAGE "Could not find a working TOL interpreter. Searched paths: ${TOL_SEARCH_PATHS}"
)

# Set cache variables
mark_as_advanced(TOL_EXECUTABLE)

# Create imported target
if(TOL_FOUND AND NOT TARGET TOL::Interpreter)
    add_executable(TOL::Interpreter IMPORTED)
    set_target_properties(TOL::Interpreter PROPERTIES
        IMPORTED_LOCATION "${TOL_EXECUTABLE}"
    )
endif()

# Provide information about found TOL
if(TOL_FOUND)
    if(NOT TOL_FIND_QUIETLY)
        message(STATUS "Found TOL interpreter:")
        message(STATUS "  Executable: ${TOL_EXECUTABLE}")
        message(STATUS "  Version: ${TOL_VERSION}")
        message(STATUS "  Platform ID: ${TOL_PLATFORM_ID}")
    endif()
    
    # Set additional variables for convenience
    set(TOL_INTERPRETER ${TOL_EXECUTABLE})
    
    # Function to run TOL commands
    function(tol_execute_command)
        set(options QUIET)
        set(oneValueArgs OUTPUT_VARIABLE ERROR_VARIABLE RESULT_VARIABLE WORKING_DIRECTORY)
        set(multiValueArgs COMMAND)
        cmake_parse_arguments(TOL_EXEC "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
        
        if(NOT TOL_EXEC_WORKING_DIRECTORY)
            set(TOL_EXEC_WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
        endif()
        
        execute_process(
            COMMAND ${TOL_EXECUTABLE} ${TOL_EXEC_COMMAND}
            WORKING_DIRECTORY ${TOL_EXEC_WORKING_DIRECTORY}
            OUTPUT_VARIABLE _output
            ERROR_VARIABLE _error
            RESULT_VARIABLE _result
            OUTPUT_STRIP_TRAILING_WHITESPACE
            ERROR_STRIP_TRAILING_WHITESPACE
        )
        
        if(TOL_EXEC_OUTPUT_VARIABLE)
            set(${TOL_EXEC_OUTPUT_VARIABLE} "${_output}" PARENT_SCOPE)
        endif()
        
        if(TOL_EXEC_ERROR_VARIABLE)
            set(${TOL_EXEC_ERROR_VARIABLE} "${_error}" PARENT_SCOPE)
        endif()
        
        if(TOL_EXEC_RESULT_VARIABLE)
            set(${TOL_EXEC_RESULT_VARIABLE} "${_result}" PARENT_SCOPE)
        endif()
        
        if(NOT TOL_EXEC_QUIET AND _result)
            message(WARNING "TOL command failed with result: ${_result}")
            message(WARNING "Error output: ${_error}")
        endif()
    endfunction()
    
else()
    if(TOL_FIND_REQUIRED)
        message(FATAL_ERROR "TOL interpreter is required but was not found")
    elseif(NOT TOL_FIND_QUIETLY)
        message(STATUS "TOL interpreter not found")
    endif()
endif()

# Debug information
if(TOL_FIND_DEBUG OR CMAKE_FIND_DEBUG_MODE)
    message(STATUS "TOL Find Debug Information:")
    message(STATUS "  Searched executable names: ${TOL_EXECUTABLE_NAMES}")
    message(STATUS "  Searched paths: ${TOL_SEARCH_PATHS}")
    message(STATUS "  Found executable: ${TOL_EXECUTABLE}")
    message(STATUS "  Executable valid: ${TOL_EXECUTABLE_VALID}")
    message(STATUS "  Version: ${TOL_VERSION}")
    message(STATUS "  Platform ID: ${TOL_PLATFORM_ID}")
endif()
