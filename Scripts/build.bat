@echo off
cd ..
set "password=%cd%"
echo Current Directory: %cd%
set "newPath=%password:REPOS=BUILDS%"
set "newPath=%newPath:UAT=%"
mkdir "%newPath%" 2>nul
echo Build Directory: %newPath%

if exist "%password%\alertapiserver\" (
    echo alertapiserver directory found
	start cmd /K "cd /d %password%\alertapiserver &&  sbt update clean compile publishLocal dist && "C:\Program Files\WinRAR\WinRAR.exe" x "%password%\alertapiserver\target\universal\alert-api-server-1.0.zip" "%newPath%""
) else (
    echo alertapiserver directory not found
)

if exist "%password%\alertjobserver\" (
    echo alertjobserver directory found
	start cmd /K "cd /d %password%\alertjobserver &&  sbt update clean compile publishLocal dist && "C:\Program Files\WinRAR\WinRAR.exe" x "%password%\alertjobserver\target\universal\alert-job-server-1.0.zip" "%newPath%""
) else (
    echo alertjobserver directory not found
)

if exist "%password%\alert-agent\" (
    echo alert-agent directory found
	start cmd /K "cd /d %password%\alert-agent &&  sbt update clean compile publishLocal dist && "C:\Program Files\WinRAR\WinRAR.exe" x "%password%\alert-agent\target\universal\alert-agent-1.0.zip" "%newPath%""
) else (
    echo alert-agent directory not found
)

if exist "%password%\alert-mobile-credential\" (
    echo alert-mobile-credential directory found
	start cmd /K "cd /d %password%\alert-mobile-credential &&  sbt update clean compile publishLocal dist && "C:\Program Files\WinRAR\WinRAR.exe" x "%password%\alert-mobile-credential\target\universal\alert-mobile-credential-1.0.zip" "%newPath%""
) else (
    echo alert-agent directory not found
)