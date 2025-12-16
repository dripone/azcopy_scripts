@echo off
setlocal

:: ==== Config ====
set "LOGDIR=C:\azcopy\Logs"
set "SCRIPTSDIR=C:\azcopy\scripts"

:: Directory
if not exist "%LOGDIR%" mkdir "%LOGDIR%"

:: Date YYYY-MM extraction (DE: TT.MM.JJJJ)
for /f "tokens=1-3 delims=." %%a in ("%date%") do (
    set "DD=%%a"
    set "MM=%%b"
    set "YYYY=%%c"
 )

:: Logs with prefix
set "LOGFILE=%LOGDIR%\azcopy_%YYYY%-%MM%.log"

:: ==== Flow ====
call :log "Script started ---------------------------------------------"

call "%SCRIPTSDIR%\AzLoginSp.cmd"
call :log "AzLoginSp ended (Exitcode: %ERRORLEVEL%)"

call "%SCRIPTSDIR%\DailyFileUpload.cmd"
call :log "DailyFileUpload ended (Exitcode: %ERRORLEVEL%)"

call "%SCRIPTSDIR%\DeleteExports.cmd"
call :log "DeleteExports ended (Exitcode: %ERRORLEVEL%)"

REM call :log "Script ended -----------------------------------------------"

endlocal
exit /b

:: ==== Functions ====
:log
echo [%date% %time%] %~1 >> "%LOGFILE%"
exit /b
