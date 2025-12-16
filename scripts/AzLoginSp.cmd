@echo off

REM ===================================================
REM 0. Define variables
REM ===================================================
set AZURE_TENANT_ID=<Tenant ID>
set AZURE_CLIENT_ID=<Client ID>
set AZURE_SUBSCRIPTION_ID=<Sub ID>

for /f "delims=" %%i in (%~dp0secret.env) do set %%i

REM ===================================================
REM 1. Login with Service Principal
REM ===================================================

REM Login mit Service Principal
az login --service-principal ^
    --username %AZURE_CLIENT_ID% ^
    --password %AZURE_CLIENT_SECRET% ^
    --tenant %AZURE_TENANT_ID%

REM Set subscription (if multiple are available)
az account set --subscription %AZURE_SUBSCRIPTION_ID%

REM Hide secret file
REM attrib +h secret.env

REM Show secret file again
REM attrib -h secret.env
