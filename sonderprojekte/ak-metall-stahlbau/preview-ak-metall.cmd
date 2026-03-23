@echo off
setlocal

set "SITE_DIR=C:\Users\timon\OneDrive\01 Nierste-Distribution\07_Projekte\Show Websites\showcases\ak-metall-stahlbau"
set "START_PAGE=%SITE_DIR%\index.html"

if exist "C:\Program Files\Google\Chrome\Application\chrome.exe" (
  start "" "C:\Program Files\Google\Chrome\Application\chrome.exe" "%START_PAGE%"
) else (
  start "" "%START_PAGE%"
)

endlocal
