# -*- coding:utf-8 -*-
import tweepy

from speed.news import News
from speed.tasks import syncToPianPianNi
from urllib import urlencode

def mb_substr(s, start, length=None, encoding="UTF-8") :
    u_s = s.decode(encoding)
    return (u_s[start:(start+length)] if length else u_s[start:]).encode(encoding)

class MyStreamListener(tweepy.StreamListener):
    def on_status(self, status):
        text = status.text.encode('utf-8')

        print("receive new msg {}".format(text))

        username = status.user.name

        description = text

        photos = [m['media_url'] for m in status.entities.get("media", []) if m['type'] == 'photo']

        description += '<br/>' + ''.join(['<img src="http://www.pianpianni.com/twimg/?{}" />'.format(urlencode({"source": photo})) for photo in photos])

        print text

        #news = News()
        #news.title = "[{}]{}".format(username, mb_substr(text, 0, 100))
        #news.description = description
        #news.source = News.SOURCE_TWITTER
        #news.link = ""
        #news.date_time = int(int(status.timestamp_ms) / 1000)

        
         re.search( r'http.*', s)
        news.title = "[{}]{}".format(username, mb_substr(text, 0, 100))
        news.description = description
        news.source = News.SOURCE_TWITTER
        news.link = ""
        news.date_time = int(int(status.timestamp_ms) / 1000)
        
#        syncToPianPianNi.delay(news)

        print("synced to painpianni")

    def on_error(self, status_code):
        print(status_code)
        if status_code == 420:
            #returning False in on_data disconnects the stream
            return False

    def on_exception(self, exception):
        print(exception)

if __name__ == "__main__":

    print("starting twitter...")

    consumer_key = 'cgsToh635hhTLI92QCvwoXAi9'
    consumer_secret = 'bYs430o0HrRn13oNNVglNVhGqRk2E6jnKZRT4RxoOaQLIOapAS'

    access_token = '908190164702265344-DezpdjljdUtFuUgEF5sTYI2OAFZMsau'
    access_token_secret = 'Z7kileifKka5p0R45wcWuVIREhS2qemxLPj5UitCJHFo3'

    auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
    auth.set_access_token(access_token, access_token_secret)

    myStreamListener = MyStreamListener()
    myStream = tweepy.Stream(auth=auth, listener=myStreamListener)

    myStream.userstream()
