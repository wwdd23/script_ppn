#!/usr/bin/env python
#-*- coding:utf-8 -*-
############################
#File Name:
#Author: wudi
#Mail: programmerwudi@gmail.com
#Created Time: 2019-01-09 11:27:53
############################



curl -u elastic:8vPhB^JvuVf 'es-cn-0pp0xisaj0009sp7o.public.elasticsearch.aliyuncs.com:9200/filebeat/my_type/'?pretty -d '{"title": "One", "tags": ["ruby"]}'




from elasticsearch import Elasticsearch, RequestsHttpConnection
import certifi
es = Elasticsearch(
    ['es-cn-0pp0xisaj0009sp7o.public.elasticsearch.aliyuncs.com'],
    http_auth=('elastic', '8vPhB^JvuVf'),
    port=9200,
    use_ssl=False
)
res = es.index(index="my_index", doc_type="my_type", id=1, body={"title": "One", "tags": ["ruby"]})
print(res['created'])
res = es.get(index="my-index", doc_type="my-type", id=1)
print





curl -u username:password 'http://<HOST>:9200/filebeat/my_type/'?pretty -d '{"title": "One", "tags": ["ruby"]}'




curl http://es-cn-0pp0xisaj0009sp7o.public.elasticsearch.aliyuncs.com:9200/index_name/type_name -XPOST -d '{"title": "One", "tags": ["ruby"]}'

