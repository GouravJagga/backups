#!/bin/bash
current_path=$(pwd)
command
echo $current_path

if [[ -d "$current_path/alertplatform" ]]; then
    echo "Directory 'n' exists in $current_path"
else 
	 echo "$current_path/alertplatform  doesn't exist"
fi