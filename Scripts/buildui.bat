@echo off
set "password=%cd%"
echo Current Directory: %cd%
set "newPath=%password:REPOS=BUILDS%"
set "newPath=%newPath:UAT\=%"
set "newPath=%newPath:alert-ui=%"
mkdir "%newPath%" 2>nul
echo Build Directory: %newPath%

if exist "%newPath%\alert-ui\" (
    echo deleting and coying alert-ui
	start cmd /K "rmdir /s /q "%newPath%\alert-ui" && xcopy "%password%" "%newPath%\alert-ui" /E /C /I /H /Y && cd "%newPath%\alert-ui" && sencha app build development"
) else (
start cmd /K "xcopy "%password%" "%newPath%\alert-ui" /E /C /I /H /Y && cd "%newPath%\alert-ui" && sencha app build development"
)
if exist "%newPath%\agent-ui\" (
    echo deleting and coying agent-ui
	start cmd /K "rmdir /s /q "%newPath%\agent-ui" && xcopy "%password%" "%newPath%\agent-ui" /E /C /I /H /Y  && cd "%newPath%\agent-ui" && python C:\WORKSPACES\backups\Scripts\findandreplace.py application.json "\"enableAgentUI\": false," "\"enableAgentUI\": true," && sencha app build development"
) else (
start cmd /K "xcopy "%password%" "%newPath%\agent-ui" /E /C /I /H /Y && cd "%newPath%\agent-ui" && sencha app build development"
)
if exist "%newPath%\mobcred-ui\" (
    echo deleting and coying agent-ui
	start cmd /K "rmdir /s /q "%newPath%\mobcred-ui" && xcopy "%password%" "%newPath%\mobcred-ui" /E /C /I /H /Y && cd "%newPath%\mobcred-ui" && python C:\WORKSPACES\backups\Scripts\findandreplace.py application.json "\"enableMobileCloudUI\": false," "\"enableMobileCloudUI\": true,"  && sencha app build development"
) else (
start cmd /K "xcopy "%password%" "%newPath%\mobcred-ui" /E /C /I /H /Y && cd "%newPath%\mobcred-ui" && sencha app build development"
)