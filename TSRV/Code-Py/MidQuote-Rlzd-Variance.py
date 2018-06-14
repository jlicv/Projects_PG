# -*- coding: utf-8 -*-
"""
Created on Mon Nov 20 20:46:48 2017

@author: Jason Li
"""


import pandas as pd
log_rtn = pd.Series.from_csv('log_rtn.csv')
square_rtn = log_rtn**2

var_hour = square_rtn.resample('1H').sum()
var_hour = var_hour.fillna(0)
var_hour.plot()
#::40，意思是每隔40个Tick抽一个点。
#你可以不年化先。比较完以后再一起年化。
var_hour_s40 = square_rtn.resample('1H').apply(lambda x:sum(x[::40]))
var_hour_s40.plot()

#从小时来统计笔数，感觉都是挺稳定的，除了少量只有200-300笔，基本上每小时都是1400笔左右。
tick_hour_count = log_rtn.resample('1H').count()
tick_hour_count = tick_hour_count.iloc[tick_hour_count.nonzero()]
vol_hour_ann = pow(var_hour.iloc[var_hour.nonzero()]/tick_hour_count*365*24,0.5)
vol_hour_ann.plot()
