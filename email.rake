
Emailer.send_custom_file(['wwdd.23@163.com'],  "btc矿机数据", XlsGen.gen(send_out), "btc矿机数据.xls" ).deliver_




# btc / glod 价格数据
#


#

btc_mc = BtcMarketCap.all.map{|n| [n.time*1000, n.value.to_f]}
gold_mc = GoldDailyUsd.where(:type => "day").map{|n| [n.time*1000, n.market_cap_value.to_f]}
compute_mc = []
btc_mc.each do |n|
  time = n[0]
  value = n[1]
  gold_info = gold_mc.select{|m| m[0] == time}.first
  if gold_info.present?
    g_value = gold_info[1]
    compute_mc << [time, Storage::Base.get_ratio(value, g_value)]
  end
end

gold_out = [["time", "btc_market_cap", "gold_market_cap", "btc / gold"]]
btc_mc.each do |n|
  time = n[0]
  g = gold_mc.select{|m| m[0] == time}.first
  c_mc = compute_mc.select{|m| m[0] == time}.first
  gold_out << [time, n[1], g.try(:[],1), c_mc.try(:[],1)]
end




#
#
# btc price history 
#
#
#
btc_price = BtcMarketPrice.all.map{|n| [n.time*1000, n.value.to_f]}






#
# bubble 泡沫指数

btc_mc = BtcMarketCap.all.map{|n| [n.time * 1000, n.value.to_f]}
btc_wu = BtcWalletUser.where(:type => "daily").map{|n| [n.time * 1000, n.value.to_f]}
btc_index = []
btc_wu.each do |n|
  mc = btc_mc.select{|m|m[0]== n[0]}
  if mc.present?
    d =  Storage::Base.get_ratio( mc.first[1]*10**4, n[1]**2)
    next if d > 10**6
    #btc_index << [n[0], Storage::Base.get_ratio( mc.first[1]*10**4, n[1]**2)]
    btc_index << [n[0], d]
  end
end

bubble_out = [["time", "btcmarketcap", "walletuser", "bubble_index"]]
btc_mc.each do |n|
  time = n[0]
  w = btc_wu.select{|m| m[0] == time}.first
  b_index = btc_index.select{|m| m[0] == time}.first
  bubble_out << [time, n[1], w.try(:[],1), b_index.try(:[],1)]
end;nil





Emailer.send_custom_file(['wwdd.23@163.com'],  "导出画图数据信息", XlsGen.gen(gold_out, btc_price, bubble_out), "绘图导出数据.xls" , true).deliver_now






out = [["类别", "类别ID", "事件事件", "内容", "html_info", "URL"]]
BigEvent.each do |n|
  out << [n.category, n.category_id, n.event_date, n.info, n.html_info, n.url]
end

Emailer.send_custom_file(['wwdd.23@163.com'],  "大事件导出信息", XlsGen.gen(out), "大事件导出数据.xls" , true).deliver_now
