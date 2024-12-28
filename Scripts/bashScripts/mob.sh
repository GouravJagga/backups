#!/bin/bash

@echo off
cd ..
currentPath=$(pwd)

echo "Current Directory: $currentPath"
# Replace "REPOS" with "BUILDS" and remove "UAT"
newPath="${currentPath//REPOS/BUILDS}"
newPath="${newPath//UAT/}"
# Navigate to the 'alert-api-server-1.0' directory
cd "$newPath/alert-mobile-credential-1.0" || exit

# Check if the RUNNING_PID file exists and delete it, otherwise print a message
if [ -f "RUNNING_PID" ]; then
  rm "RUNNING_PID"
  echo "RUNNING_PID file deleted."
else
  echo "RUNNING_PID file does not exist."
fi

# Run the Java application with specified options
java -cp "./lib/*" -Dconfig.file=conf/application.conf -Xms2g -Xmx2g -Xss4M -Dhttp.port=9095 -Dpidfile.path="NUL" -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=0.0.0.0:9997 -Dlogback.debug=true -Djava.awt.headless=true -Dlog4j.configurationFile=conf/log4j2.xml -Dorg.owasp.esapi.resources=conf play.core.server.ProdServerStart

# Navigate back to the 'alert-ui' directory
cd ../alert-ui || exit
