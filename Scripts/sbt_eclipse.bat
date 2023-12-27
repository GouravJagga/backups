@echo off

set "path=%cd%"
echo Current Directory: %cd%

set "sbtCommand="

if exist "%path%\alertplatform\" (
    echo alertplatform directory found
    set "sbtCommand=cd /d %path%\alertplatform && sbt eclipse"
) else (
    echo alertplatform directory not found
)

if exist "%path%\alertreconstaging\" (
    echo alertreconstaging directory found
    if defined sbtCommand (
        set "sbtCommand=%sbtCommand% && cd /d %path%\alertreconstaging && sbt eclipse"
    ) else (
        set "sbtCommand=cd /d %path%\alertreconstaging && sbt eclipse"
    )
) else (
    echo alertreconstaging directory not found
)

if exist "%path%\alertserver\" (
    echo alertserver directory found
    if defined sbtCommand (
        set "sbtCommand=%sbtCommand% && cd /d %path%\alertserver && sbt eclipse"
    ) else (
        set "sbtCommand=cd /d %path%\alertserver && sbt eclipse"
    )
) else (
    echo alertreconstaging directory not found
)

if exist "%path%\alertapiserver\" (
    echo alertapiserver directory found
    if defined sbtCommand (
        set "sbtCommand=%sbtCommand% && cd /d %path%\alertapiserver && sbt eclipse"
    ) else (
        set "sbtCommand=cd /d %path%\alertapiserver && sbt eclipse"
    )
) else (
    echo alertapiserver directory not found
)

if exist "%path%\alertjobserver\" (
    echo alertjobserver directory found
    if defined sbtCommand (
        set "sbtCommand=%sbtCommand% && cd /d %path%\alertjobserver && sbt eclipse"
    ) else (
        set "sbtCommand=cd /d %path%\alertjobserver && sbt eclipse"
    )
) else (
    echo alertjobserver directory not found
)

if exist "%path%\alert-agent\" (
    echo alert-agent directory found
    if defined sbtCommand (
        set "sbtCommand=%sbtCommand% && cd /d %path%\alert-agent && sbt eclipse"
    ) else (
        set "sbtCommand=cd /d %path%\alert-agent && sbt eclipse"
    )
) else (
    echo alert-agent directory not found
)
call %sbtCommand%
