#!/bin/bash

cd ..
currentPath=$(pwd)
echo "Current Directory: $currentPath"

# Replace "REPOS" with "BUILDS" and remove "UAT"
newPath="${currentPath//REPOS/BUILDS}"
newPath="${newPath//UAT/}"
mkdir -p "$newPath"
echo "Build Directory: $newPath"

# Declare an associative array for the directory and zip mapping
declare -A directories=(
    ["api"]="alertapiserver"
    ["job"]="alertjobserver"
    ["agent"]="alert-agent"
    ["mob"]="alert-mobile-credential"
)

# Check if the argument is valid and process accordingly
if [[ -n "${directories[$1]}" ]]; then
    dir=${directories[$1]}
    if [ -d "$currentPath/$dir" ]; then
        echo "$dir directory found"
        cd "$currentPath/$dir"
        
        # Run sbt commands and check for errors
        sbt update clean compile publishLocal dist
        if [ $? -ne 0 ]; then
            echo "Error during sbt build for $dir. Exiting."
            exit 1
        fi

        # Construct the zip file path dynamically based on the argument
        case "$1" in
            "api")
                zipFile="$currentPath/$dir/target/universal/alert-api-server-1.0.zip"
                ;;
            "job")
                zipFile="$currentPath/$dir/target/universal/alert-job-server-1.0.zip"
                ;;
            "agent")
                zipFile="$currentPath/$dir/target/universal/alert-agent-1.0.zip"
                ;;
            "mob")
                zipFile="$currentPath/$dir/target/universal/alert-mobile-credential-1.0.zip"
                ;;
            *)
                echo "Invalid argument provided. Exiting."
                exit 1
                ;;
        esac

        # Check if the zip file exists and extract it
        if [ -f "$zipFile" ]; then
            echo "Extracting $zipFile to $newPath"
            unzip -o "$zipFile" -d "$newPath"
        else
            echo "Zip file $zipFile not found."
        fi
    else
        echo "$dir directory not found"
    fi
else
    echo "Invalid argument. Please provide either 'api', 'job', 'agent', or 'mob'."
fi
