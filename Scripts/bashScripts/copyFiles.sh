#!/bin/bash

@echo off
cd ..
currentPath=$(pwd)

echo "Current Directory: $currentPath"
# Replace "REPOS" with "BUILDS" and remove "UAT"
newPath="${currentPath//REPOS/BUILDS}"
newPath="${newPath//UAT/}"

# Enable associative arrays
declare -A file_map

# Populate the associative array with file paths and their copy destinations
file_map["${newPath}/alert-api-server-1.0/conf/environment.conf"]="$currentPath/alertapiserver/conf/environment.conf"
file_map["$newPath/alert-job-server-1.0/conf/environment.conf"]="$currentPath/alertjobserver/conf/environment.conf"
file_map["$newPath/alert-agent-1.0/conf/environment.conf"]="$currentPath/alert-agent/conf/environment.conf"
file_map["$newPath/alert-mobile-credential-1.0/conf/environment.conf"]="$currentPath/alert-mobile-credential/conf/environment.conf"

# Iterate over the associative array and copy files
for source_file in "${!file_map[@]}"; do
  destination_dir="${file_map[$source_file]}"
  
  # Check if the source file exists
  if [[ -f "$source_file" ]]; then
    # Copy the file to the destination directory
    cp "$source_file" "$destination_dir"
    echo "Copied $source_file to $destination_dir"
  else
    echo "Source file $source_file does not exist."
  fi
done

