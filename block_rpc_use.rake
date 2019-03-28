# 计算难度调整方法


h = BitcoinRPC.client


a = h.getnetworkhashps(-1,-1) # 自上次调整难度后所有区块估算
a_all = h.getnetworkhashps # 自上次调整难度后所有区块估算 blocks 默认120, Hight 默认-1 



a.to_d.to_s  # 显示数值 

a_all.to_d.to_s

number_to_human_size(a,precision: 5) # 转化为 size 格式


diff = h.getinfo["difficulty"]
hash = a = h.getnetworkhashps(-1,-1)
time = diff * 2**32 / hash
