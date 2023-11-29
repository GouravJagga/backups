@echo off

set "password=%cd%"
echo Current Directory: %cd%

set "sbtCommand="

if exist "%password%\alertplatform\" (
    echo alertplatform directory found
    set "sbtCommand=cd /d %password%\alertplatform && sbt eclipse"
) else (
    echo alertplatform directory not found
)

if exist "%password%\alertreconstaging\" (
    echo alertreconstaging directory found
    if defined sbtCommand (
        set "sbtCommand=%sbtCommand% && cd /d %password%\alertreconstaging && sbt eclipse"
    ) else (
        set "sbtCommand=cd /d %password%\alertreconstaging && sbt eclipse"
    )
) else (
    echo alertreconstaging directory not found
)

if exist "%password%\alertserver\" (
    echo alertserver directory found
    if defined sbtCommand (
        set "sbtCommand=%sbtCommand% && cd /d %password%\alertserver && sbt eclipse"
    ) else (
        set "sbtCommand=cd /d %password%\alertserver && sbt eclipse"
    )
) else (
    echo alertreconstaging directory not found
)

if exist "%password%\alertapiserver\" (
    echo alertapiserver directory found
    if defined sbtCommand (
        set "sbtCommand=%sbtCommand% && cd /d %password%\alertapiserver && sbt eclipse"
    ) else (
        set "sbtCommand=cd /d %password%\alertapiserver && sbt eclipse"
    )
) else (
    echo alertapiserver directory not found
)

if exist "%password%\alertjobserver\" (
    echo alertjobserver directory found
    if defined sbtCommand (
        set "sbtCommand=%sbtCommand% && cd /d %password%\alertjobserver && sbt eclipse"
    ) else (
        set "sbtCommand=cd /d %password%\alertjobserver && sbt eclipse"
    )
) else (
    echo alertjobserver directory not found
)

if exist "%password%\alert-agent\" (
    echo alert-agent directory found
    if defined sbtCommand (
        set "sbtCommand=%sbtCommand% && cd /d %password%\alert-agent && sbt eclipse"
    ) else (
        set "sbtCommand=cd /d %password%\alert-agent && sbt eclipse"
    )
) else (
    echo alert-agent directory not found
)
cd %password%

call %sbtCommand%
