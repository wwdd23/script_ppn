q = ([
  {:$match => {:resolution => "D"}},
  {:$group => {
    :_id => "$symbol",
    # :data => {:$push => {:t => "$time" , :o => "$open", :h => "$high", :l => "$low", :c => "$close"}},
  }}
])
data = BitmexAllSymbol.collection.aggregate(q)
ids = data.map{|n| n["_id"]}
data = {}
ids.each do |n|
  data[n] ||= []
end

ids.each do |n|
  data[n] = BitmexAllSymbol.where(:resolution => "D", :symbol => n).map{|m| [m.time* 1000, m.open, m.high, m.low, m.close.to_f]}
end

okex_data = OkexQuarter.where(:time_at => Time.parse("2016-05-01")..Time.parse("2017-03-17")).map{|n| [(n.time - 4.hour.to_i*1000), n.open, n.high, n.low, n.close] }

# 现货价格计算  相关
bitstamp = Blockexchange.where(:name => "bitstamp", :date_at.gte => Time.parse("2016-01-01")).map{|n| [n.time * 1000, n.close * 0.5]}
gdax = ExchangeGdax.where(:coin => "BTC", :date_at.gte => Time.parse("2016-01-01")).map{|n| [n.time * 1000, n.close * 0.5]}
bxbt = []
bitstamp.each do |n|
  t = n[0]
  c = n[1]
  next if gdax.select{|m| m[0] == t}.first.try(:[], 1) == nil
  bxbt << [t, (c.to_f + gdax.select{|m| m[0] == t}.first[1].to_f)]
end

out_bitmex = {}
out_bitmex_ratio = {}

ids.each do |n|
  out_bitmex[n] ||= []
  out_bitmex_ratio[n] ||= []
end
data.each do |k,v|
  name = k
  v.each do |d|
    t = d[0]
    c = d[4]
    tmp = bxbt.select{|n| n[0] == t}.first
    next if tmp.blank?
    p tmp
    p c
    out_bitmex[k] << [t, (tmp[1] - c).round(2)]
    out_bitmex_ratio[k] << [t, ((tmp[1] - c)/tmp[1]*100).round(2)]
  end
end

out_ok= []
out_ok_ratio = []

okex_data.each do |n|
  t = n[0]
  c = n[4]
  tmp = bxbt.select{|m| m[0] == t}.first
  next if tmp.blank?
  out_ok << [t, (tmp[1] - c ).round(2)]
  out_ok_ratio << [t, (((tmp[1] - c )/tmp[1])*100).round(2)]
end;nil


a = []
a.concat(out_ok_ratio)
out_bitmex_ratio.each do |k,v|
  a.concat( v)
end


Emailer.send_custom_file(['wwdd.23@163.com'], "溢价比汇总", XlsGen.gen(a ), "溢价比汇总数据.xls").deliver_now






