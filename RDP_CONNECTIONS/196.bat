cmdkey /delete 192.168.192.196
cmdkey /delete TERMSRV/192.168.192.196
cmdkey /generic:192.168.192.196 /user:"SCL592\aeqa" /pass:"Alert1234"
start "" /B mstsc /v:192.168.192.196
exit