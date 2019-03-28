#!/usr/bin/env python
#-*- coding:utf-8 -*-
############################
#File Name:
#Author: wudi
#Mail: programmerwudi@gmail.com
#Created Time: 2018-03-13 21:59:25
############################

from urllib import urlencode
import tweepy

consumer_key = 'cgsToh635hhTLI92QCvwoXAi9'
consumer_secret = 'bYs430o0HrRn13oNNVglNVhGqRk2E6jnKZRT4RxoOaQLIOapAS'

access_token = '908190164702265344-DezpdjljdUtFuUgEF5sTYI2OAFZMsau'
access_token_secret = 'Z7kileifKka5p0R45wcWuVIREhS2qemxLPj5UitCJHFo3'

auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)


#public_tweets = api.home_timeline()
api = tweepy.API(auth)
print api
#for tweet in public_tweets:  
#    text = tweet.text.encode('utf-8')
#    #print tweet.text  
#    print tweet.text  




mysql -uwww  -pNePxTWLqTpbaHQUUi7bhnKdy -h rm-j6c57m57wu7f22oq8.mysql.rds.aliyuncs.com
