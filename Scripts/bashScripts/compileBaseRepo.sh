#!/bin/bash

cd ..
currentPath=$(pwd)

echo "Current Directory: $currentPath"
# Replace "REPOS" with "BUILDS" and remove "UAT"
newPath="${currentPath//REPOS/BUILDS}"
newPath="${newPath//UAT/}"
# Define directories and corresponding zip file paths
declare -A directories=(
    ["plat"]="alertplatform"
    ["recon"]="alertreconstaging"
    ["alert"]="alertserver"
    ["config"]="alert-config-transfer"
)
declare -A renameJars=(
    ["plat"]="com.alnt.alert-platform_2.13-1.0.jar"
    ["recon"]="com.alnt.alert-recon-staging_2.13-1.0.jar"
    ["alert"]="com.alnt.alert-server_2.13-1.0"
    ["config"]="com.alnt.alert-config-transfer_2.13-1.0.jar"
)

if [[ -n "${directories[$1]}" ]]; then
    dir=${directories[$1]}
    if [ -d "$currentPath/$dir" ]; then
        echo "$dir directory found"
        cd "$currentPath/$dir"
        
        # Run sbt commands and check for errors
        sbt update clean compile publishLocal
        if [ $? -ne 0 ]; then
            echo "Error during sbt build for $dir. Exiting."
            exit 1
        fi

        # Construct the zip file path dynamically based on the argument
        case "$1" in
            "plat")
                jarPath="$currentPath/$dir/target/scala-2.13/alert-platform_2.13-1.0.jar"
                ;;
            "recon")
                jarPath="$currentPath/$dir/target/scala-2.13/alert-recon-staging_2.13-1.0.jar"
                ;;
            "alert")
                jarPath="$currentPath/$dir/target/scala-2.13/alert-server_2.13-1.0.jar"
                ;;
            "config")
                jarPath="$currentPath/$dir/target/scala-2.13/alert-config-transfer_2.13-1.0.jar"
                ;;
            *)
                echo "Invalid argument provided. Exiting."
                exit 1
                ;;
        esac
        if [ -f "$jarPath" ]; then
            echo "copying $jarPath to BuildRepos"
			case "$1" in
            "plat")
            cp $jarPath $newPath/alert-api-server-1.0/lib/${renameJars[$1]}
			cp $jarPath $newPath/alert-job-server-1.0/lib/${renameJars[$1]}
			cp $jarPath $newPath/alert-agent-1.0/lib/${renameJars[$1]}
			cp $jarPath $newPath/alert-mobile-credential-1.0/lib/${renameJars[$1]}
                ;;
            "recon")
            cp $jarPath $newPath/alert-api-server-1.0/lib/${renameJars[$1]}
			cp $jarPath $newPath/alert-job-server-1.0/lib/${renameJars[$1]}
			cp $jarPath $newPath/alert-agent-1.0/lib/${renameJars[$1]}
			cp $jarPath $newPath/alert-mobile-credential-1.0/lib/${renameJars[$1]}
                ;;
            "alert")
            cp $jarPath $newPath/alert-api-server-1.0/lib/${renameJars[$1]}
			cp $jarPath $newPath/alert-job-server-1.0/lib/${renameJars[$1]}

                ;;
            "config")
            cp $jarPath $newPath/alert-api-server-1.0/lib/${renameJars[$1]}
                ;;
            *)
                echo "Invalid argument provided. Exiting."
                exit 1
                ;;
        esac
        else
            echo "Zip file $jarPath not found."
        fi
    else
        echo "$dir directory not found"
    fi
else
    echo "Invalid argument. Please provide either 'api', 'job', 'agent', or 'mob'."
fi