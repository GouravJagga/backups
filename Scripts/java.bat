@echo off
if "%1"=="8" (
    setx JAVA_HOME "C:\Program Files\Java\jdk1.8.0_191"
    setx JAVA_HOME "C:\Program Files\Java\jdk1.8.0_191" /m
) else if "%1"=="17" (
    setx JAVA_HOME "C:\Program Files\Java\jdk-17"
    setx JAVA_HOME "C:\Program Files\Java\jdk-17" /m
) else (
    echo Invalid argument. No action taken.
)