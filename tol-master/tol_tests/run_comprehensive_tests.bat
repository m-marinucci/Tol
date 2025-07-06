@echo off
REM ###########################################################################
REM FILE    : run_comprehensive_tests.bat
REM PURPOSE : Enhanced cross-platform test runner for Windows
REM AUTHOR  : Massimiliano Marinucci
REM DATE    : 2025-07-06
REM ISSUE   : NUM-11 - P0: Comprehensive Cross-Platform Testing Framework
REM ###########################################################################

setlocal enabledelayedexpansion

REM Configuration
set "TOL_BIN_PATH=..\windows\ActiveTol\bin\tolsh.exe"
set "TEST_DIR=%~dp0"
set "LOG_DIR=%TEST_DIR%test_logs"
set "TIMESTAMP=%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%"
set "TIMESTAMP=%TIMESTAMP: =0%"
set "LOG_FILE=%LOG_DIR%\comprehensive_test_%TIMESTAMP%.log"

REM Create log directory if it doesn't exist
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"

REM Initialize counters
set /a total_tests=0
set /a passed_tests=0
set /a failed_tests=0

echo [INFO] Starting Comprehensive Cross-Platform Testing Framework
echo [INFO] Issue: NUM-11 - P0: Comprehensive Cross-Platform Testing Framework
echo [INFO] Log file: %LOG_FILE%

REM Log system information
echo ======================================== >> "%LOG_FILE%"
echo SYSTEM DIAGNOSTICS >> "%LOG_FILE%"
echo ======================================== >> "%LOG_FILE%"
echo Date: %date% %time% >> "%LOG_FILE%"
echo Computer: %COMPUTERNAME% >> "%LOG_FILE%"
echo OS: %OS% >> "%LOG_FILE%"
echo Processor: %PROCESSOR_IDENTIFIER% >> "%LOG_FILE%"
echo TOL Binary: %TOL_BIN_PATH% >> "%LOG_FILE%"
echo ======================================== >> "%LOG_FILE%"

REM Check if TOL is available
echo [INFO] Checking TOL availability...
if not exist "%TOL_BIN_PATH%" (
    echo [ERROR] TOL binary not found at %TOL_BIN_PATH%
    echo [INFO] Trying alternative paths...
    
    REM Try alternative paths
    if exist "tolsh.exe" set "TOL_BIN_PATH=tolsh.exe"
    if exist "..\tol\tolsh.exe" set "TOL_BIN_PATH=..\tol\tolsh.exe"
    if exist "tolcon.exe" set "TOL_BIN_PATH=tolcon.exe"
    
    if not exist "!TOL_BIN_PATH!" (
        echo [ERROR] TOL binary not found. Please ensure TOL is installed and accessible.
        exit /b 1
    )
)

echo [SUCCESS] TOL binary found at %TOL_BIN_PATH%

REM Function to run a test
:run_test
set "test_name=%~1"
set "test_file=%~2"
set "timeout_val=%~3"
if "%timeout_val%"=="" set "timeout_val=300"

echo [INFO] Running test: %test_name%
echo [INFO] Test file: %test_file%

if not exist "%test_file%" (
    echo [ERROR] Test file not found: %test_file%
    set /a failed_tests+=1
    goto :eof
)

REM Run the test
"%TOL_BIN_PATH%" -v "%test_file%" >> "%LOG_FILE%" 2>&1
if !errorlevel! equ 0 (
    echo [SUCCESS] Test '%test_name%' completed successfully
    set /a passed_tests+=1
) else (
    echo [ERROR] Test '%test_name%' failed with exit code !errorlevel!
    set /a failed_tests+=1
)
goto :eof

REM Main execution
echo =========================================
echo PHASE 1: ENHANCED FRAMEWORK TESTS
echo =========================================

set /a total_tests+=1
call :run_test "Enhanced Test Runner" "%TEST_DIR%enhanced_test_runner.tol" 600

echo =========================================
echo PHASE 2: UNIT TESTS
echo =========================================

REM Unit Tests
for /d %%d in ("%TEST_DIR%unit_tests\*") do (
    if exist "%%d\test.tol" (
        set /a total_tests+=1
        for %%f in ("%%d") do set "test_name=%%~nxf"
        call :run_test "Unit Test: !test_name!" "%%d\test.tol" 300
    )
)

echo =========================================
echo PHASE 3: PERFORMANCE TESTS
echo =========================================

REM Performance Tests
for /d %%d in ("%TEST_DIR%performance_tests\*") do (
    if exist "%%d\test.tol" (
        set /a total_tests+=1
        for %%f in ("%%d") do set "test_name=%%~nxf"
        call :run_test "Performance Test: !test_name!" "%%d\test.tol" 1200
    )
)

echo =========================================
echo PHASE 4: PLATFORM TESTS
echo =========================================

REM Platform Tests
for /d %%d in ("%TEST_DIR%platform_tests\*") do (
    if exist "%%d\test.tol" (
        set /a total_tests+=1
        for %%f in ("%%d") do set "test_name=%%~nxf"
        call :run_test "Platform Test: !test_name!" "%%d\test.tol" 300
    )
)

echo =========================================
echo PHASE 5: REGRESSION TESTS
echo =========================================

REM Original regression tests
set /a total_tests+=1
call :run_test "BSR Tests" "%TEST_DIR%tol\_bsrTester.tol" 600

set /a total_tests+=1
call :run_test "Core TOL Tests" "%TEST_DIR%tol\_tolTester.tol" 600

REM Calculate results
set /a success_rate=passed_tests*100/total_tests

echo =========================================
echo COMPREHENSIVE TEST SUITE SUMMARY
echo =========================================
echo Total Tests: %total_tests%
echo Passed: %passed_tests%
echo Failed: %failed_tests%
echo Success Rate: %success_rate%%%
echo Platform: Windows
echo Log File: %LOG_FILE%

REM Check acceptance criteria
if %success_rate% geq 95 (
    echo [SUCCESS] ✅ ACCEPTANCE CRITERIA MET - Success rate >= 95%%
    set exit_code=0
) else (
    echo [ERROR] ❌ ACCEPTANCE CRITERIA NOT MET - Success rate ^< 95%%
    set exit_code=1
)

REM Final summary to log
echo ======================================== >> "%LOG_FILE%"
echo FINAL SUMMARY >> "%LOG_FILE%"
echo ======================================== >> "%LOG_FILE%"
echo Total Tests: %total_tests% >> "%LOG_FILE%"
echo Passed: %passed_tests% >> "%LOG_FILE%"
echo Failed: %failed_tests% >> "%LOG_FILE%"
echo Success Rate: %success_rate%%% >> "%LOG_FILE%"
echo Exit Code: %exit_code% >> "%LOG_FILE%"
echo ======================================== >> "%LOG_FILE%"

echo [INFO] Test execution completed. Check %LOG_FILE% for detailed results.

exit /b %exit_code%
