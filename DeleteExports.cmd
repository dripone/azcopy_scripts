@echo off

set "ARCHIV_DIR=C:\azcopy\exports\_ARCHIVE"

for %%F in ("%ARCHIV_DIR%\*.zip") do (
    powershell -NoProfile -Command ^
        "$limit=(Get-Date).AddDays(-31); $file=(Get-Item '%%F').LastWriteTime; Write-Host '%%F - LastWriteTime:' $file; if ($file -lt $limit) {Write-Host 'Deleting %%F'; Remove-Item '%%F'} else {Write-Host 'Keeping %%F'}"
)
