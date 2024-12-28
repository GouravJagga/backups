#!/bin/bash

# Navigate to the parent directory
cd ..
currentPath=$(pwd)
newPath="${currentPath//REPOS/BUILDS}"
newPath="${newPath//UAT/}"
echo "Current Directory: $currentPath"

# First, handle the directories sequentially
baseDirectories=("alertplatform" "alertreconstaging" "alertserver" "alert-config-transfer")
for dir in "${baseDirectories[@]}"; do
    if [ -d "$currentPath/$dir" ]; then
        echo "$dir directory found"
        cd "$currentPath/$dir" || exit
        sbt update clean compile publishLocal
        if [ $? -ne 0 ]; then
            echo "Error occurred while processing $dir. Exiting."
            exit 1
        fi
    else
        echo "$dir directory not found"
    fi
done

# Update the currentPath and create the build directory

mkdir -p "$newPath"
echo "Build Directory: $newPath"

# Define directories and corresponding zip file paths
declare -A directories=(
    ["alertapiserver"]="alert-api-server-1.0.zip"
    ["alertjobserver"]="alert-job-server-1.0.zip"
    ["alert-agent"]="alert-agent-1.0.zip"
    ["alert-mobile-credential"]="alert-mobile-credential-1.0.zip"
)

# Start each directory processing in a new mintty terminal
script_dir=$(dirname "$(realpath "$0")")
cd $currentPath
for dir in "${!directories[@]}"; do
    echo "Processing directory: $dir with zip file: ${directories[$dir]}" # Debugging line to show what is being processed
    mintty bash -c "cd $currentPath; $script_dir/buildallSubShell.sh \"$currentPath\" \"$newPath\" \"$dir\" \"${directories[$dir]}\"; exec bash" &
done

# Wait for all background processes to complete
wait
echo "All directory processing is complete."