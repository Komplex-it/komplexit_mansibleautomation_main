#!/usr/bin/env bash
for server in $(vl status | awk '{ print $2 ".openknowit.com"  }' )
do
  echo 	"{"
  echo  "        \"name\": \"$server\","
  echo  "        \"description\": \"Server autocreated\","
  echo  "        \"inventory\": \"serverinventory\""
  echo  "},"
done
