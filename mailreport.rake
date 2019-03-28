

###  send mail 
#


out = [["time", "date","vlaue", "type"]]
CmeBrti.each do |n|
  out << [n.timestamp, n.date_at, n.value, n.type]
end
Emailer.send_custom_file(['lucask@marvelouspeach.com'],  "CMETicker数据", XlsGen.gen(out), "CME_Ticker.xls",true ).deliver_now



send = [["date_time", "timestamp", "MarketCap_Value"]]
a = BtcMarketCap.all.map{|n| [n.date_at, n.time, n.value]} send.concat(a) 

Emailer.send_custom_file(['wwdd.23@163.com'],  "binance历史数据", XlsGen.gen(out), "binance历史交易量.xls" ).deliver


#######
#
#
#
def send
power_rate =  0.35
minings = Storage::Base::MININGS
difficulty =  BtcDifficulty.all
btc_all_price =  BtcMarketPrice.all
btc_price = btc_all_price.sort_by{|n| n.value_at}.map{|n| [n.value_at.to_i * 1000, n.value.to_f.round(2)]}
minings_diff = Storage::Base::MININGS.sort_by{|k,v| v[:sell_date]}.map{|k,v| [k, v[:sell_date].to_date.to_s , v[:power], v[:hashrate], v[:power]/v[:hashrate]]}
info_out = {}
# 同时期最牛B的矿机列表
best_list = []
# 时间降序，对比功耗比，如果新机器功耗比小于最后一位，入栈
# last show minings 时间线中需要同时显示的矿机类型
need_show = [ "Innosilicon T2", "神马M10"]

if type != "origin"
  minings_diff.each_with_index do |x,y|
    if y == 0
      best_list << x
    else
      if x[4] < best_list.last[4] ||  need_show.include?(x[0])
        best_list << x
      end
    end
  end
else
  minings_diff.each_with_index do |x,y|
    if y == 0
      best_list << x
    else
      if x[4] < best_list.last[4]
        best_list << x
      end
    end
  end
end
      minings_name = best_list.map{|m| m[0]}
      select_minings = Storage::Base::MININGS.select{|k,v| minings_name.include?(k)}
      dates = select_minings.map{|k,v| v[:sell_date]}.sort.uniq

      #相同发布时间取最优过滤 power/hashrate 越小越好
      info = dates.map do |n|
        #(Storage::Base::MININGS.select{|k,v| v[:sell_date] == n}.sort_by{|k,v| (v[:power] / v[:hashrate])}.first)
        (select_minings.select{|k,v| v[:sell_date] == n}.sort_by{|k,v| (v[:power] / v[:hashrate])}.first)
      end
       # 计算矿机数据区间
      list_count = info.count
      info.each_with_index do |x, y|
        num = y + 1
        hashrate = x[1][:hashrate]
        start_day = x[1][:sell_date].to_time
        power = x[1][:power]
        next_info = info[num]

        if type != "origin"
          if  num < (list_count - 2)  # 倒数第二个矿机同时显示
            end_day = next_info[1][:sell_date]
            info_out[x[0]] = {:hashrate => hashrate, :power => power, :start_day => start_day, :end_day => end_day}
            #info_out[x[0]] = {:hashrate => hashrate, :power => power}
          else
            info_out[x[0]] = {:hashrate => hashrate, :power => power, :start_day => start_day, :end_day => Time.now}
            #info_out[x[0]] = {:hashrate => hashrate, :power => power}
          end

        else

          if next_info.present?
            end_day = next_info[1][:sell_date]
            info_out[x[0]] = {:hashrate => hashrate, :power => power, :start_day => start_day, :end_day => end_day}
            #info_out[x[0]] = {:hashrate => hashrate, :power => power}
          else
            info_out[x[0]] = {:hashrate => hashrate, :power => power, :start_day => start_day, :end_day => Time.now}
            #info_out[x[0]] = {:hashrate => hashrate, :power => power}
          end
        end
      end
      # info_out 为矿机计算出数据list
      top_send = {}
      top_send_power = {}
      info_out.each do |k,v|
        top_send[k] ||= []
        top_send_power[k] ||= []
      end

        all_top_minings = Compute::Charts.analysis_minings( "btc", difficulty, btc_price, power_rate, info_out, "top_minings")




        out = [["时间", "电费成本"]]
        all_top_minings[:power].each do |k,v|
          out.concat v
        end

         Emailer.send_custom_file(['wwdd.23@163.com'],  "btc电费成本数据", XlsGen.gen(out), "btc电费成本数据.xls" ).deliver_now



        send_out = [["time", "Time_at","difficulty", "hashrate","mining", "mining_hashrate", "mining_power", "minning_price"]]

        send_out = [ ["time", "time_at", "mining_price"] ]
        btc_hash_rate = BtcHashrate.all
        difficulty.each do |n|
          t= n.time
          diff_value = n.value
          
          time_at = Time.at t
          bhr =  BtcHashrate.where(:time => t).first.try(:value)

          #mining_select_info = info_out.select{|k,v| v[:start_day].to_i >= time/1000 && v[:end_day].to_i < time/1000}
          mining_select_info = info_out.select{|k,v| v[:start_day] <= Time.at(t) && Time.at(t) < v[:end_day]}
          p t
          p mining_select_info
          if mining_select_info.present?
            mining_name = mining_select_info.keys.first
            p mining_name
            mining_hashrate = mining_select_info.values.first[:hashrate]
            mining_power = mining_select_info.values.first[:power]
            m_info = Storage::Base::MININGS[mining_name]
            m_price = m_info[:price]
            #m_price = m_info[:hashrate]
            #send_out << [t, time_at, diff_value, bhr, mining_name. mining_hashrate, mining_power, m_price ]
            send_out << [t, time_at , m_price]
          end
        end;nil

        Emailer.send_custom_file(['wwdd.23@163.com'],  "btc矿机数据", XlsGen.gen(send_out), "btc矿机数据.xls" ).deliver_now


end




###  eth 矿机预测数据总表
#
#



send_out = [["time", "Time_at","difficulty", "hashrate","mining", "mining_hashrate", "mining_power", "minning_price"]]

send = {}
send_power = {}
send_history_cost= {}
#minings = Storage::Base::ETH_MININGS
minings.each do |k,v|
  send[k] ||= []
  send_power[k] ||= []
  send_history_cost[k] ||= [] #电价成本比
end
base = EthDifficulty.all
diff_data = base.map{|n| [n.time*1000, n.value.to_f]}
eth_price = EthMarketPrice.days.map{|n| [n.time*1000 , n.value.to_f]}
minings.each do |k,v|
  hashrate = v[:hashrate]
  #diff = v[:value]
  sell_date = v[:sell_date]
  power_info = v[:power].to_f
  if (type == "top_minings")
    start_day= v[:start_day]
    end_day = v[:end_day]
    base_value = base.where(:value_at => start_day.to_date..end_day.to_date).sort_by{|n| n.value_at}.map{|n|
      [n.time*1000, n.value.to_f]
    }
    base_hash = EthHashrate.where(:value_at => start_day.to_date..end_day.to_date)
  else
    base_value = base.where(:value_at.gte => sell_date).sort_by{|n| n.value_at}.map{|n|
      [n.time*1000, n.value.to_f]
    }
    base_hash = EthHashrate.where(:value_at.gte => sell_date)
  end
  base_value.each do |n|
    if n[0] < Time.parse('2017-10-17').to_i * 1000
      coin_hashrate = base_hash.where(:time => n[0]/1000).first
      cal = Compute::Charts.eth_calculator(n[1].to_f, coin_hashrate.try(:value).to_f, hashrate, 0)
      e_cost = Compute::Charts.eth_elec_cost(cal[:pre_day].to_f, power_info, power_rate)
      send[k] << ([n[0], cal[:pre_day].to_f.round(8)])
      send_power[k] << ([n[0], e_cost ])
      price_info = eth_price.select{|data| data[0] == n[0]}
      price = price_info.present? ? price_info.first[1] : 0.to_f
      send_history_cost[k] << ([n[0], Storage::Base.get_ave(price, e_cost)]) #币价/成本
    elsif n[0] >= Time.parse('2017-10-17').to_i * 1000
      coin_hashrate = base_hash.where(:time => n[0]/1000).first
      cal = Compute::Charts.eth_calculator(n[1].to_f, coin_hashrate.try(:value).to_f, hashrate, 1)
      e_cost = Compute::Charts.eth_elec_cost(cal[:pre_day].to_f, power_info, power_rate)
      send[k] << ([n[0], cal[:pre_day]])
      send_power[k] << ([n[0], e_cost ])
      price_info = eth_price.select{|data| data[0] == n[0]}
      price = price_info.present? ? price_info.first[1] : 0.to_f
      send_history_cost[k] << ([n[0], Storage::Base.get_ave(price, e_cost) ]) #币价/成本
    end
  end
  Emailer.send_custom_file(['wwdd.23@163.com'],  "矿机数据", XlsGen.gen(send_out), "矿机数据.xls" ).deliver




