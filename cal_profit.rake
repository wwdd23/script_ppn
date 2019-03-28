


data = BtcBchProfit.where(:miner => "Bitfury Tardis B8", :profit_btc_bch.ne => nil)

a = [["time", "btc_bch", "btc_sv"]]



start_info = nil

b =  []
data.each do |n|
  o = 0
  if start_info.present?
    if start_info > 105 
      o = 1
    elsif start_info < 103
      o = 2
    end
  end
 a <<  [n.created_at,n.profit_btc_bch, o,  n.profit_btc_sv]
  start_info = n.profit_btc_bch
end

#a.concat b

Emailer.send_custom_file(['k@marvelouspeach.com'],  "收益比历史整理", XlsGen.gen(a), "收益比整理.xls").deliver_now





BtcBchProfit.all.map{|n|

  if (n.btc_bch / n.btc_day * 100) != n.profit_btc_bch
    p n.created_at

    n.update!(:profit_btc_bch => (n.btc_bch / n.btc_day * 100), :profit_btc_sv => (n.btc_sv / n.btc_day * 100))
  end

};nil





#  Bch 矿机切换

out = [["timestamp", "time", "btc_bch ratio"]]

BtcBchProfit.where(:miner => "Bitfury Tardis B8", :profit_btc_bch.ne => nil).each do |n|
  time = n.timestamp
  end_time = time + 10.minutes.to_i
  bch_btc_count = n.bch_day 
  btc_day = n.btc_day
  data  = BinaceBch.where(:coin => "BCHABCBTC", :time => (time * 1000)..(end_time * 1000))

  start_info = nil
  data.each do |m|
    btc_bch = bch_btc_count * m.c
    profit = btc_bch / btc_day * 100
    o = 0
    if start_info.present?


      if start_info > 105 && o == 1
        o = 1
      elsif start_info > 105 && o == 0
        o = 1
      elsif (103 <= start_info && start_info < 105) && o == 1
        o = 1
      elsif (start_info < 103) && o == 1
        o = 0
      elsif (103 <= start_info && start_info < 105) && o == 0
        o = 0
      end
    end
    out <<  [m.time / 1000, Time.at(m.time/1000),  profit, o]
    start_info = profit
  end
end

Emailer.send_custom_file(['woody@marvelouspeach.com'],  "收益比历史整理20181225_1", XlsGen.gen(out), "1225_1收益比整理.xls",true).deliver_now
