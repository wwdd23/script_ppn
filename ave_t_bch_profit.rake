BtcBchProfitBtcBchProfit




b_all_data = BtcBchProfit.where(:created_at.gte => 5.days.ago, :miner => "Bitfury Tardis B8").map{|n| (n.bch_day / n.miner_hashrate)};nil

b = (b_all_data.sum / b_all_data.count).to_f




a_name ="神马矿机M10S（正常模式）"

a_all_data = BtcBchProfit.where(:created_at.gte => 5.days.ago, :miner => a_name).map{|n| (n.bch_day / n.miner_hashrate)}

n = (a_all_data.sum / a_all_data.count).to_f





2.3.1 :039 >   n = (a_all_data.sum / a_all_data.count).to_f
 => 0.0011135706649217556
2.3.1 :040 > b
 => 0.0011135706649217556


  => 0.0011387115780400034
