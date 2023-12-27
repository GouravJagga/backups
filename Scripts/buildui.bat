@echo off
set "password=%cd%"
echo Current Directory: %cd%
set "newPath=%password:REPOS=BUILDS%"
set "newPath=%newPath:UAT\\=%"
mkdir "%newPath%" 2>nul
echo Build Directory: %newPath%

if exist "%newPath%\alert-ui\" (
    echo deleting and coying alert-ui
	start cmd /K "rmdir /s /q "%newPath%\alert-ui" && xcopy "%password%\alert-ui" "%newPath%\alert-ui" /E /C /I /H /Y && cd "%newPath%\alert-ui" && sencha app build development"
) else (
start cmd /K "xcopy "%password%\alert-ui" "%newPath%\alert-ui" /E /C /I /H /Y && cd "%newPath%\alert-ui" && sencha app build development"
)
if exist "%newPath%\agent-ui\" (
    echo deleting and coying agent-ui
	start cmd /K "rmdir /s /q "%newPath%\agent-ui" && xcopy "%password%\alert-ui" "%newPath%\agent-ui" /E /C /I /H /Y && cd "%newPath%\agent-ui" && sencha app build development"
) else (
start cmd /K "xcopy "%password%\alert-ui" "%newPath%\agent-ui" /E /C /I /H /Y && cd "%newPath%\agent-ui" && sencha app build development"
)