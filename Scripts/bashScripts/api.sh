#!/bin/bash

@echo off
cd ..
currentPath=$(pwd)

echo "Current Directory: $currentPath"
# Replace "REPOS" with "BUILDS" and remove "UAT"
newPath="${currentPath//REPOS/BUILDS}"
newPath="${newPath//UAT/}"
# Navigate to the 'alert-api-server-1.0' directory
cd "$newPath/alert-api-server-1.0" || exit

# Check if the RUNNING_PID file exists and delete it, otherwise print a message
if [ -f "RUNNING_PID" ]; then
  rm "RUNNING_PID"
  echo "RUNNING_PID file deleted."
else
  echo "RUNNING_PID file does not exist."
fi

# Run the Java application with specified options
java -cp "./lib/*" -Dconfig.file=conf/application.conf \
    -Xms4g -Xmx4g -Xss4M -Dhttp.port=9000 -Dpidfile.path="/dev/null" \
    -Dlogback.debug=true -Xdebug \
    -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=0.0.0.0:9999 \
    -Djava.awt.headless=true -Dmail.smtp.starttls.enable=true \
    -Dmail.smtp.ssl.protocols=TLSv1.2 -Dlog4j.configurationFile=conf/log4j2.xml \
    -Dorg.owasp.esapi.resources=conf play.core.server.ProdServerStart

# Navigate back to the 'alert-ui' directory
cd ../alert-ui || exit
