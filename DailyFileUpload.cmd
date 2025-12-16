@echo off

// Azure CLI is needed

set "AZCOPY_LOG_LOCATION=C:\azcopy\Logs"

setlocal enabledelayedexpansion

REM ===================================================
REM 2. Configuration
REM ===================================================

set "SRC_DIR=C:\azcopy\exports"
set "DIRECTORY=<DIR_NAME>"
set "ARCHIV_DIR=%SRC_DIR%\_ARCHIVE"
if not exist "%ARCHIV_DIR%" mkdir "%ARCHIV_DIR%"

set "STORAGE_ACCOUNT=<STORAGE_NAME>"

REM ENVIRONMENT in Storage Acc
set "CONTAINER=<CONTAINER_NAME>"

REM List of directories
set "EXPORTS=<DIR_NAME1 DIR_NAME2>"

REM Path to AzCopy
set "AZCOPY=C:\azcopy\azcopy.exe"

REM ===================================================
REM 3. Generate SAS token dynamically (valid for 15 minutes)
REM ===================================================
for /f "usebackq" %%i in (`powershell -NoProfile -Command "$utcNow = (Get-Date).ToUniversalTime(); $utcNow.ToString('yyyy-MM-ddTHH:mmZ')"`) do set START=%%i
REM echo Start (UTC): %START%

for /f "usebackq" %%i in (`powershell -NoProfile -Command "$utcNow = (Get-Date).ToUniversalTime().AddMinutes(15); $utcNow.ToString('yyyy-MM-ddTHH:mmZ')"`) do set EXPIRY=%%i
REM echo End (UTC): %EXPIRY%

for /f "delims=" %%i in ('az storage container generate-sas --account-name %STORAGE_ACCOUNT% --name %CONTAINER% --permissions rlw --start %START% --expiry %EXPIRY% --auth-mode login --as-user -o tsv') do set SAS=%%i

if "%SAS%"=="" (
    echo Error: SAS could not be generated!
    exit /b 1
)

REM ===================================================
REM 4. Loop through all exports and upload with SAS
REM ===================================================
for %%E in (%EXPORTS%) do (
    set "FOLDER=%SRC_DIR%\%%E"
    if exist "!FOLDER!" (
        echo Uploading %%E ...
        "%AZCOPY%" copy "!FOLDER!\*.*" "https://%STORAGE_ACCOUNT%.blob.core.windows.net/%CONTAINER%/%DIRECTORY%/%%E?%SAS%"
        if !errorlevel! equ 0 (
            echo Moving %%E into archive...
            move "!FOLDER!\*.*" "%ARCHIV_DIR%"
        ) else (
            echo Error during upload: %%E!
        )
    ) else (
        echo Source %%E doesn't exist...
    )
)
echo Upload completed on: %date% %time%

REM ===================================================
REM 5. Zip all CSV files in the archive folder
REM ===================================================
for /f "delims=" %%i in ('powershell -NoProfile -Command "$dt = Get-Date; $dt.ToString('yyyyMMdd_HHmmss')"') do set ZIPSTAMP=%%i
set "ZIPNAME=Export_%ZIPSTAMP%.zip"
set "ZIPPATH=%ARCHIV_DIR%\%ZIPNAME%"
powershell -NoProfile -Command "Compress-Archive -Path '%ARCHIV_DIR%\*.csv' -DestinationPath '%ZIPPATH%' -Force"
echo Archived CSV files zipped to: %ZIPPATH%
del /q "%ARCHIV_DIR%\*.csv"
echo All CSV files deleted from archive folder.
exit /b 0
