




date_time = "2017-03-02"


date = date_time.to_date


#交易时期区分表

list = okex_year_future_list(date)


 list.each do |n|

   p "#{n[0].to_s}, #{n[1].to_s}"


 end



base_okex = OkexQuarter.where(:time_at => list.first.first..list.last.last).map{|n| [n.time,  n.open, n.high, n.low, n.close]}


count = 100


time = 1501300800000/1000
base_okex.each do |n|

  time = n.time/1000
  "2017-09-22".to_date


  start_price = 1 / price

  if list.select{|l| l[0] == time.to_date} #交割并买入新合约


  end

  out_data < [n[0], n[1]*count, n[2]*count, n[3]*count, n[4]*count]
end


list.each_with_index do |n,index|

  p index

end
