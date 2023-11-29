@echo off

set "password=%cd%"
echo Current Directory: %cd%

set "sbtCommand="

if exist "%password%\alertplatform\" (
    echo alertplatform directory found
    set "sbtCommand=cd /d %password%\alertplatform && sbt update clean compile publishLocal "
) else (
    echo alertplatform directory not found
)

if exist "%password%\alertreconstaging\" (
    echo alertreconstaging directory found
    if defined sbtCommand (
        set "sbtCommand=%sbtCommand% && cd /d %password%\alertreconstaging && sbt update clean compile publishLocal "
    ) else (
        set "sbtCommand=cd /d %password%\alertreconstaging && sbt update clean compile publishLocal"
    )
) else (
    echo alertreconstaging directory not found
)

if exist "%password%\alertserver\" (
    echo alertserver directory found
    if defined sbtCommand (
        set "sbtCommand=%sbtCommand% && cd /d %password%\alertserver && sbt update clean compile publishLocal "
    ) else (
        set "sbtCommand=cd /d %password%\alertserver && sbt update clean compile publishLocal"
    )
) else (
    echo alertreconstaging directory not found
)
cd %password%

call %sbtCommand%
