set "password1=%cd%"
cd ..
set "password=%cd%"
set "newPath=%password:BUILDS=REPOS%"
copy "%password%\alert-api-server-1.0\conf\environment.conf" "%newPath%\UAT\alertapiserver\conf"
copy "%password%\alert-api-server-1.0\conf\cache.conf" "%newPath%\UAT\alertapiserver\conf"
copy "%password%\alert-job-server-1.0\conf\environment.conf" "%newPath%\UAT\alertjobserver\conf"
copy "%password%\alert-job-server-1.0\conf\cache.conf" "%newPath%\UAT\alertjobserver\conf"
copy "%password%\alert-agent-1.0\conf\environment.conf" "%newPath%\UAT\alert-agent\conf"
copy "%password%\alert-agent-1.0\conf\cache.conf" "%newPath%\UAT\alert-agent\conf"
cd %password1%