@echo off
REM ==========================================
REM Rebuild Script for OnlineBankingTransactionSystem
REM ==========================================

echo.
echo ========================================
echo Rebuilding OnlineBankingTransactionSystem
echo ========================================
echo.

cd /d "%~dp0"

echo Cleaning solution...
"C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe" OnlineBankingTransactionSystem.sln /t:Clean /p:Configuration=Debug /v:minimal

echo.
echo Rebuilding solution...
"C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe" OnlineBankingTransactionSystem.sln /t:Rebuild /p:Configuration=Debug /v:minimal

echo.
if %ERRORLEVEL% EQU 0 (
    echo ========================================
    echo BUILD SUCCESSFUL!
    echo ========================================
    echo.
    echo The parser error should now be fixed.
    echo You can now run your application.
    echo.
) else (
    echo ========================================
    echo BUILD FAILED!
    echo ========================================
    echo.
    echo Please open Visual Studio and rebuild manually:
    echo 1. Open OnlineBankingTransactionSystem.sln
    echo 2. Build -^> Rebuild Solution
    echo.
)

pause
