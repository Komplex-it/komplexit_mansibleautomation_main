#!/usr/bin/env bash

if [[ $2 == "clean" ]];
then
	awx tokens list --all|jq .results[].id|xargs -i{} awx tokens delete {}
fi


if [[ -f  /etc/systemd/system/kalm.service ]];
then
	echo "`date`: The service file is present"
else
	echo "`date`: The service file is missing"
	exit
fi



grep "FILLTHETOKEN" /etc/systemd/system/kalm.service >/dev/null 2>&1
if [[ $? == 0 ]];
then
	echo "`date`: The service file needs a token"
	TOKEN=$(awx tokens create --conf.color 0 --description "kalm" -f json  |jq .token -r)
	sudo sed -i "s/FILLTHETOKEN/${TOKEN}/" /etc/systemd/system/kalm.service
else
	echo "`date`: The service file has a token"
fi

cat /etc/systemd/system/kalm.service |grep "Environment=" | awk -F'Environment=' '{ print "export " $2 }' |tr -d '"'  > ~/kalm.env
source ~/kalm.env
env |grep TOWER_HOST
python3 ~/awxping.py
if [[ $? == 0 ]];
then
	echo "`date`: our token is working"
else
	echo "`date`: our token is not working"
	exit 2
fi


