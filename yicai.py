#!/usr/bin/env python
#-*- coding:utf-8 -*-
############################
#File Name:
#Author: wudi
#Mail: programmerwudi@gmail.com
#Created Time: 2018-03-01 17:19:18
############################
import hashlib
import json
import re

import sys

import time
from datetime import datetime

import random

import requests


from pyquery import PyQuery as pq



import urllib2, httplib
import StringIO, gzip


reload(sys)
sys.setdefaultencoding('utf-8')

#logger = get_task_logger(__name__)


#logger.info("开始抓取yicai")



#     "Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.63 Safari/537.36 SE 2.X MetaSr 1.0",
#         "Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.143 Safari/537.36",
#         "Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.99 Safari/537.36 LBBROWSER",
#         "Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.118 UBrowser/5.2.2466.104 Safari/537.36",
# 
_REQUEST_DEFAULT_HEADERS = {

        "User-Agent": "Mozilla/5.0 (Windows NT 6.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.63 Safari/537.36",

        # "User-Agent": "Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.99 Safari/537.36 LBBROWSER",


        # "User-Agent": "Mozilla/5.0 (Windows NT 6.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.63 Safari/537.36",

        # "User-Agent": "Mozilla/5.0 (Windows NT 6.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.63 Safari/537.36",

        # "User-Agent": "Mozilla/5.0 (Windows NT 6.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.63 Safari/537.36",
        # "content-type": "gzip",
        # "Cache-Control": "max-age=0"
        }

now = datetime.now()
day_str = now.strftime('%Y-%m-%d')
url = "http://www.yicai.com/api/ajax/hourList/1/" + day_str

r = requests.get(url, headers=_REQUEST_DEFAULT_HEADERS)

if r.status_code != 200:
    raise Exception("抓取yicai失败 status code: {}, error: {}".format(r.status_code, r.text))

html = r.content

#html = unicode(open(html).read(), "utf-8")
print(html)
q = pq(html)

print q 
list = q("li")




for item in list:
    
    #print item
    item = pq(item)


    # compressedstream = StringIO.StringIO(item)
    # gziper = gzip.GzipFile(fileobj=compressedstream)
    # item = gziper.read()   # 读取解压缩后数据



    title = str(item.find(".txt p.f-ff1").text()).strip().encode('latin1').decode('utf8') 

    time_str = str(item.find(".txt h4").text()).strip()

    time_arr = time.strptime("{} {}".format(day_str, time_str), "%Y-%m-%d %H:%M")
    timestamp = int(time.mktime(time_arr))

    print title.encode('latin1').decode('utf8') 




    #news = News()
    #news.title = title
    #news.description = "{}".format(title)
    ##news.source = News.SOURCE_YICAI
    #news.link = ""
    #news.date_time = timestamp
    

#    process_news.apply_async((news,))

#logger.info("结束抓取yicai")

print "抓取结束yicai"
