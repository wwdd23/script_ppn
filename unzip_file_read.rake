#!/usr/bin/env python
#-*- coding:utf-8 -*-
############################
#File Name:
#Author: wudi
#Mail: programmerwudi@gmail.com
#Created Time: 2018-09-03 17:03:59
############################

require 'find'
require 'zlib'
require 'open-uri'


Find.find('/Users/wudi/ppn/ppn_data/data/kline') do |path|
  #puts path
  if path.include?("csv.gz")
    #p path
    date = path.match(/kiline\/(.*)\/BINANCE/)[1]
    if date.present?
      source = open(a)
      gz = Zlib::GzipReader.new(source)
      result = gz.read
      d = CSV.read(result)

    end

  end

end






