#!/bin/bash
cd ..
currentPath=$(pwd)
echo "Current Directory: $currentPath"
directories=("alertplatform" "alertreconstaging" "alertserver" "alert-config-transfer" "alertapiserver" "alertjobserver" "alert-agent" "alert-mobile-credential")
for dir in "${directories[@]}"; do
    if [ -d "$currentPath/$dir" ]; then
        echo "$dir directory found"
        cd $currentPath/$dir 
		sbt eclipse
		if [ $? -ne 0 ]; then
			echo "Error occurred while processing $dir. Exiting."
			exit 1
		fi
    else
        echo "$dir directory not found"
    fi
done
cd "$currentPath/alert-ui"
