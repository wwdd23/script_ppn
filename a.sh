#!/bin/bash
###################
# Author:  wudi
# Mail: programmerwudi@gmail.com 
# Description: 
# Created Time: 2018-11-16 00:40:58
###################
count=1
while [ $count -le 10000000 ]; do
  curl 47.75.7.181:8332/rest/chaininfo.json
  sleep 2
done
e
