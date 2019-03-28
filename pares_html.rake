require 'httparty'
require 'nokogiri'

url ='https://etherscan.io/chart/tx'
response = HTTParty.get  url 
puts response.body
doc = Nokogiri::HTML response.body
doc.css('.js-issue-title').each do  |node|
  puts node.content
end

s = doc.css('script')
s.children


require 'rkelly'

parser = RKelly::Parser.new
ast    = parser.parse(
  s.children.first
)


link = doc.search('script').children.first


t = link.text



t.gsub!(/\r\n/, "")
t.gsub!(/ /, "")

datas = t.match(/data: (\[.*},        \])/)[1]

datas.gsub!("difficulty", '"difficulty"').gsub!("dt", '"dt"').gsub!("estHashrate", '"estHashrate"').gsub!("blockTime", '"blockTime"').gsub!('blockSize', '"blockSize"').gsub!("blockCount", '"blockCount"').gsub!("unclesCount", 'unclesCount').gsub!( "newaddress", '"newaddress"').gsub!("y :", '"y" :').gsub!(" : ", ":")

h = eval(datas)

h[-3..-1]





#### 获取页面中数据
#
#
url = "https://cash.coin.dance/blocks/todaysq"

response = HTTParty.get  url
puts response.body
doc = Nokogiri::HTML response.body



link = doc.search('script')
t = link.children.last
t = link.text
t.gsub!(/\n\t\t\t\t/, "")
t.gsub!(/\n\t\t\t/, "")
t.gsub!(/\n\t\t/, "")
t.gsub!(/\n\t/, "")
t.gsub!(/\n/, "")
t.gsub!(/ /, "")
t.gsub!(/\\/, "")


datas = t.match(/"data\":[(.*)]/)1]
datas = t.match(/\"data\":\[(.*)\"6CDCF9\"}]'/)

datas = t.match(/dataSource:'(.*)\}\]\}'/)

step1 = t.match(/newFusionCharts\(\{(.*);chart.render\(\)/)[1]

step2 = step1.match(/\"data\":\[(.*)\]/)[1]

x = "["+step2+"]"

h = eval x


### 获取 btc com


url = "/blocks/todaysq"
url = "https://bch.btc.com/stats/pool?pool_mode=day"
response = HTTParty.get  url
puts response.body
doc = Nokogiri::HTML response.body


link = doc.search('script')
t = link.children.first.to_s




t.gsub!(/\n\t\t\t\t/, "")
t.gsub!(/\n\t\t\t/, "")
t.gsub!(/\n\t\t/, "")
t.gsub!(/\n\t/, "")
t.gsub!(/\n/, "")
t.gsub!(/ /, "")
t.gsub!(/\\/, "")


datas = t.match(/"data\":[(.*)]/)1]
datas = t.match(/\"data\":\[(.*)\"6CDCF9\"}]'/)

datas = t.match(/dataSource:'(.*)\}\]\}'/)

step1 = t.match(/newFusionCharts\(\{(.*);chart.render\(\)/)[1]

step2 = step1.match(/\"data\":\[(.*)\]/)[1]

x = "["+step2+"]"

h = eval x




