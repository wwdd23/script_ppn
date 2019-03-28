#!/bin/bash
###################
# Author:  wudi
# Mail: programmerwudi@gmail.com 
# Description: 
# Created Time: 2018-11-16 00:40:58
###################
count=1
while [ $count -le 10000000 ]; do
  echo "abc"
  curl 47.90.97.238:8332/rest/chaininfo.json
  sleep 2
done
e
