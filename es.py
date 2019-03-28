#!/usr/bin/env python
#-*- coding:utf-8 -*-
############################
#File Name:
#Author: wudi
#Mail: programmerwudi@gmail.com
#Created Time: 2019-01-10 17:14:42
############################


from elasticsearch import Elasticsearch
from elasticsearch.helpers import bulk

import time
import argparse
import sys
reload(sys)
sys.setdefaultencoding('utf-8')

import psycopg2
con = None

con = psycopg2.connect(host="pgm-j6cg805891v49q1o.pg.rds.aliyuncs.com", port="3433", database="postgres", user="coinsummer", password="NFmD2K$LwRJ")
cur = con.cursor()
cur.execute("SELECT * FROM medium_news")
rows = cur.fetchall()
try:
    #con = psycopg2.connect(database="wudi", user="wudi", host="127.0.0.1", port="5432")
    con = psycopg2.connect(host="pgm-j6cg805891v49q1o.pg.rds.aliyuncs.com", port="3433", dbname="postgres", user="coinsummer", password="NFmD2K$LwRJ")
    cur = con.cursor()
    cur.execute("SELECT * FROM medium_news")
    rows = cur.fetchall()
    for row in rows:
        print(row)
except psycopg2.DatabaseError as e:
    print('Error %s' % e)
    sys.exit(1)
finally:
    if con:
        con.close()

class es_tool():
    # 类初始化函数
    def __init__(self, hosts, timeout):
        self.es = Elasticsearch(hosts, timeout=5000)
        pass

    # 将数据存储到es中
    def set_data(self, fields_data=[], index_name=INDEX_NAME, doc_type_name=TYPE_NAME):
        # 创建ACTIONS
        ACTIONS = []
        # print "es set_data length",len(fields_data)
        for fields in fields_data:
            # print "fields", fields
            # print fields[1]
            action = {
                    "_index": index_name,
                    "_type": doc_type_name,
                    "_source": {
                        "id": fields[0],
                        "tweet_id": fields[1],
                        "user_id": fields[2],
                        "user_screen_name": fields[3],
                        "tweet": fields[4]
                        }
                    }
            ACTIONS.append(action)

        # print "len ACTIONS", len(ACTIONS)
        # 批量处理
        success, _ = bulk(self.es, ACTIONS, index=index_name, raise_on_error=True)
        print('Performed %d actions' % success)



# 初始化es，设置mapping
def init_es(hosts=[], timeout=5000, index_name=INDEX_NAME, doc_type_name=TYPE_NAME):
    es = Elasticsearch(hosts, timeout=5000)
    my_mapping = {
            TYPE_NAME: {
                "properties": {
                    "id": {
                        "type": "string"
                        },
                    "tweet_id": {
                        "type": "string"
                        },
                    "user_id": {
                        "type": "string"
                        },
                    "user_screen_name": {
                        "type": "string"
                        },
                    "tweet": {
                        "type": "string"
                        }
                    }
                }
            }
    try:
        # 先销毁，后创建Index和mapping
        delete_index = es.indices.delete(index=index_name)  # {u'acknowledged': True}
        create_index = es.indices.create(index=index_name)  # {u'acknowledged': True}
        mapping_index = es.indices.put_mapping(index=index_name, doc_type=doc_type_name,
                body=my_mapping)  # {u'acknowledged': True}
        if delete_index["acknowledged"] != True or create_index["acknowledged"] != True or mapping_index["acknowledged"] != True:
            print "Index creation failed..."
    except Exception, e:
        print "set_mapping except", e

# 主函数
if __name__ == '__main__':
    # args = read_args()
    # 初始化es环境
    init_es(hosts=["localhost:9200"], timeout=5000)
    # 创建es类
    es = es_tool(hosts=["localhost:9200"], timeout=5000)
    # 执行写入操作
    tweet_list = [("111","222","333","444","555"), ("11","22","33","44","55")]
    es.set_data(tweet_list)


