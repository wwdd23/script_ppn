=begin

1. 将数据通过 time 作为 Key 统计 
```
:history => {

time => { "xbtm17" => [溢价，溢价比],
          "xbth18" => [溢价， 溢价比]
        }, 
time => ...
}
```

each history key
如果time start 溢价比小于 负溢价均值开仓 进行开仓平仓判断。
当time 结果中数量大于1时，进行移仓判断。

1. 前期为正溢价状态 若下一期为负溢价 且 达到开仓标准, 则移仓到下一期， 下一次记录选择相同期货区间


def add_postition(data_array, time_datas)
  last_data = data_array
  time_data


end




2. 前期为负溢价，若下期平仓标准出现正溢价则移仓到下一期并平仓


当期，下期判断， 同一time 中，后2位相同，比较第三位 字符顺序

=end

# 数据创建
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
all_bitmext = {}
BitmexAllSymbol.where(:resolution => "D").each do |n|
  all_bitmext[n.time] ||= {}
  # 现货价格
  bxbt_price = bxbt.select{|bx|  bx[0] == n.time*1000}.first.try(:[], 1)
  if bxbt_price.present? 
    diff_price = (n.close - bxbt_price)
    raito_diff = (diff_price / bxbt_price * 100).round(2)
    all_bitmext[n.time].merge!({n.symbol => [diff_price, raito_diff ]})
  end
end
all_okex = {}
OkexQuarter.where(:time_at => Time.parse("2016-05-01")..Time.parse("2017-03-17")).each do |n|
  all_okex[(n.time- 4.hour.to_i*1000)/1000] ||= {}
  bxbt_price = bxbt.select{|bx|  bx[0] == (n.time- 4.hour.to_i*1000)}.first.try(:[], 1)
  if bxbt_price.present? 
    diff_price = (n.close - bxbt_price)
    raito_diff = (diff_price / bxbt_price * 100).round(2)
    all_okex[(n.time- 4.hour.to_i*1000)/1000].merge!({"okex"=> [diff_price, raito_diff ]})
  end
end
base_data = all_okex.merge!( all_bitmext)

# 1. 计算负溢价均值
x = out_bitmex_ratio.map{|k,v| v}.flatten(1)
all_ratio = x + out_ok_ratio 
negative_base = all_ratio.select{|n| n[1]<0}
neg_ave = negative_base.map{|n| n[1]}.instance_eval { reduce(:+) / size.to_f }
positive_base = all_ratio.select{|n| n[1]>0}
pos_ave = positive_base.map{|n| n[1]}.instance_eval { reduce(:+) / size.to_f }
out = []
base_data.each do |k,v|
  time = k
  values = v
  next if values.blank?
  if values.count == 1
    index_data = values.value.first
    diff_price = index_data[0]
    diff_ratio = index_data[1]
    # init first data
    if diff_ratio < neg_ave && out.blank?
      out << [values.keys.first, diff_price, diff_ratio]
    end
    last_data = out.last
    if lost_data.present? 
      if diff_ratio < lost_data[2] && last_data[2] < 0
        p "1 #{n}"
        next
      elsif diff_ratio > pos_ave && last_data[2] < neg_ave
        p "2 #{n}"
        out << [value.keys, n[1],  Time.at(n[0]/1000)]
        elsif last_data[1] > pos_ave && n[1] > 0 # 最后一个值为正溢价 不添加
        p "3 #{n}"
        next
      elsif last_data[1] > pos_ave && n[1] < neg_ave # 最后一个为正溢价，n1 小于负溢价均值添加
        p "4 #{n}"
        b_data[k] << [n[0], n[1], Time.at(n[0]/1000) ]
        #b_data[k] << n
      end
    end




  elsif values.count > 1

  end
end





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








