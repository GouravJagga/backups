#!/bin/bash

currentPath="$1"
newPath="$2"
dir="$3"
zipFile="$4"

process_directory() {
    if [ -d "$currentPath/$dir" ]; then
        echo "$dir directory found"
        cd "$currentPath/$dir" || exit

        # Run sbt commands
        sbt update clean compile publishLocal dist
        if [ $? -ne 0 ]; then
            echo "Error during sbt build for $dir. Exiting."
            exit 1
        fi

        # Extract the resulting zip file
        if [ -f "$currentPath/$dir/target/universal/$zipFile" ]; then
            echo "Extracting $zipFile to $newPath"
            unzip "$currentPath/$dir/target/universal/$zipFile" -d "$newPath"
        else
            echo "Zip file $zipFile not found."
        fi
    else
        echo "$dir directory not found"
    fi
}

process_directory
