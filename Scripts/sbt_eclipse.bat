@echo off

cd ..
set "current_path=%cd%"
echo Current Directory: %cd%
rem List of directories to check
set "directories=alertplatform alertreconstaging alertserver alertapiserver alertjobserver alert-agent alert-mobile-credential"
for %%d in (%directories%) do (
    if exist "%current_path%\%%d\" (
        echo %%d directory found
		cd %current_path%\%%d\ && sbt eclipse
    ) else (
        echo %%d directory not found
    )
)

echo %sbtCommand%
if defined sbtCommand (
    call %sbtCommand%
)
