#q = ([ {:$match => {:resolution => "D"}}, {:$group => { :_id => "$symbol", }} ])
#data = BitmexAllSymbol.collection.aggregate(q)
#ids = data.map{|n| n["_id"]}
#data = {}
#ids.each do |n|
#  data[n] ||= []
#end

ids = BitmexAllSymbol.all.map(&:symbol).uniq
ids.each do |n|
  data[n] = BitmexAllSymbol.where(:resolution => "D", :symbol => n).map{|m| [m.time* 1000, m.open, m.high, m.low, m.close.to_f]}
end

okex_data = OkexQuarter.where(:time_at => Time.parse("2016-05-01")..Time.parse("2017-03-17")).map{|n| [(n.time - 4.hour.to_i*1000), n.open, n.high, n.low, n.close] }

# 现货价格计算  相关
bitstamp = Blockexchange.where(:name => "bitstamp", :date_at.gte => Time.parse("2016-03-01")).map{|n| [n.time * 1000, n.close * 0.5]}
gdax = ExchangeGdax.where(:coin => "BTC", :date_at.gte => Time.parse("2016-03-01")).map{|n| [n.time * 1000, n.close * 0.5]}
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
    out_bitmex[k] << [t, (c - tmp[1]).round(2)]
    out_bitmex_ratio[k] << [t, ((c - tmp[1] )/tmp[1]*100).round(2)]
  end
end

out_ok= []
out_ok_ratio = []

okex_data.each do |n|
  t = n[0]
  c = n[4]
  tmp = bxbt.select{|m| m[0] == t}.first
  next if tmp.blank?
  out_ok << [t, ( c - tmp[1] ).round(2)]
  out_ok_ratio << [t, ((( c - tmp[1] )/tmp[1])*100).round(2)]
end;nil

=begin

# 获取基础数据
1. 计算负溢价平均值
2. 计算正溢价均值
3. 筛选负溢价超过均值的时间点以及季度合约名称
4. 筛选正溢价超过均值的时间点以及季度合约名称

# 当季度统计
# 当季负溢价开始，正溢价平仓，若未结束，顺序负溢价开仓
# 负溢价通过阈值开仓，

=end

# 1. 计算负溢价均值

x = out_bitmex_ratio.map{|k,v| v}.flatten(1)

all_ratio = x + out_ok_ratio 


negative_base = all_ratio.select{|n| n[1]<0}
neg_ave = negative_base.map{|n| n[1]}.instance_eval { reduce(:+) / size.to_f }
positive_base = all_ratio.select{|n| n[1]>0}
pos_ave = positive_base.map{|n| n[1]}.instance_eval { reduce(:+) / size.to_f }


b_data = {}

ids.each do |n|
  b_data[n] ||= []
end
=begin
    # 当负溢价小于均值时添加，if 溢价率小于最后一个值不添加，直到大于正溢价时添加
    # 当最后一个值为正溢价后，不追加
    # 当最后一个值为正溢价后，正溢价大于最后一个替换最后一个正溢价， 若小于最后一个正溢价不变更 (最优逻辑）
    #
    # 当最后一个为正溢价，后当负溢价小于均值后追加，并执行第一个策略
=end
out_bitmex_ratio.each do |k,v|
   p k
  v.each do |n|
    if n[1] < neg_ave && b_data[k].blank?
      p "0 #{n}"
      b_data[k] << [n[0], n[1],  Time.at(n[0]/1000)]
    end
    last_data = b_data[k].last
    if last_data.present? 
      if n[1] < last_data[1] && last_data[1] < 0 # 小于最后一个数值不添加
        p "1 #{n}"
        next
      elsif n[1] > pos_ave && last_data[1] < neg_ave # 正溢价且 最后一个值为 负溢价 添加平仓时间点
        p "2 #{n}"
        b_data[k] << [n[0], n[1],  Time.at(n[0]/1000)]
      elsif last_data[1] > pos_ave && n[1] > 0 # 最后一个值为正溢价 不添加
        p "3 #{n}"
        next
      elsif last_data[1] > pos_ave && n[1] < neg_ave # 最后一个为正溢价，n1 小于负溢价均值添加
        p "4 #{n}"
        b_data[k] << [n[0], n[1], Time.at(n[0]/1000) ]
        #b_data[k] << n
      end
    end
  end
end;nil

ok_data = []
out_ok_ratio.each do |n|
  if n[1] < neg_ave && ok_data.blank?
    p "0 #{n}"
    ok_data << [n[0], n[1],  Time.at(n[0]/1000)]
  end
  last_data = ok_data.last
  if last_data.present? 
    if n[1] < last_data[1] && last_data[1] < 0 # 小于最后一个数值不添加
      p "1 #{n}"
      next
    elsif n[1] > pos_ave && last_data[1] < neg_ave # 正溢价且 最后一个值为 负溢价 添加平仓时间点
      p "2 #{n}"
      ok_data <<  [n[0], n[1], Time.at(n[0]/1000) ]
    elsif last_data[1] > pos_ave && n[1] > 0 # 最后一个值为正溢价 不添加
      p "3 #{n}"
      next
    elsif last_data[1] > pos_ave && n[1] < neg_ave # 最后一个为正溢价，n1 小于负溢价均值添加
      p "4 #{n}"
      ok_data <<  [n[0], n[1],  Time.at(n[0]/1000)]
    end
  end
end


mail_out = []
b_data.each do |k,v|
  mail_out << [k]
  v.each do |n|
    mail_out << n
  end
end
mail_out << ["okex"]
mail_out.concat(ok_data)
Emailer.send_custom_file(['wwdd.23@163.com'], "季度合约区间仓位回测测试_#{Time.now.to_i}", XlsGen.gen(mail_out), "#{Time.now.to_i}_mail_out.xls").deliver_now


#show data
#
b_data.each do |k,v|

  p k
  v.each do |n|
    p Time.at(n[0]/1000) , n[1]
  end

end








