date = Time.now.to_date 



# 本季度最后一个周五时间

# 本季度末
q = date.end_of_quarter

def analysis_future_start(time)
  date = time.to_time.to_date
  this_q_start = date.beginning_of_quarter - 1.day
  p this_q_start
  wday = this_q_start.wday  
  # 当季度合约结束日期
  case wday
  when 0,6
    q_start_day = this_q_start.prev_week.monday + 4.day
  when 5
    q_start_day = this_q_start-1.week
  else
    q_start_day = this_q_start.prev_week.prev_week.monday + 4.day
  end

  return q_start_day

end

def analysis_future_quarter(time)
  date = time.to_time.to_date
  this_q_end = date.end_of_quarter
  this_q_start = date.beginning_of_quarter 
  wday = this_q_end.wday  
  # 当季度合约结束日期
  q_start_day = analysis_future_start(this_q_start.to_s) 
  case wday
  when 0,6
    q_end_day = this_q_end.monday + 4.day
    next_q_start_day =  this_q_end.monday.prev_week + 4.day
  when 5
    q_end_day = this_q_end
    next_q_start_day =  this_q_end.prev_week + 4.day
  else
    q_end_day = this_q_end.prev_week + 4.day
    next_q_start_day = this_q_end.monday.prev_week + 4.day
  end

  key_m = q_end_day.month
  key_day = q_end_day.day
  p "合约ID  BTC0#{key_m}#{key_day} 开始时间#{q_start_day}, 结束时间#{q_end_day}"
  return [q_start_day, q_end_day]
  #p "本季度合约结束#{q_end_day}, 下季度开始#{next_q_start_day}"
  #如果31不是周末  结算日期为 prev 周周五
  # 如果是 周日 最后一周周五是  this_day - 2.day
  # 如果是 周6 最后一周周五是  this_day - 1.day
end



def okex_year_future_list(date)
  year = date.year
  future_list = []
  (year..Time.now.to_date.year).each do |year|
    start_date = Time.parse("#{year}-01-01").to_date
    (1..4).each do |n|
      future_list << analysis_future_quarter(start_date.to_s)
      start_date = start_date.end_of_quarter + 1.day
    end
  end
  return future_list
end
