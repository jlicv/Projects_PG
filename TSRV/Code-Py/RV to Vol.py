# -*- coding: utf-8 -*-
"""
Created on Wed Nov 22 11:08:42 2017

@author: Jason Li
"""

import pandas as pd
log_rtn = pd.Series.from_csv('log_rtn.csv')
square_rtn = log_rtn**2


#问题在于说，我现在的Estimator是每天的，但我取样的时候，
#每隔X分钟取数据，不一定能够取到。
#尤其是Tick的数据的时候。
#我只能够做一个粗略的近似。
#例如说每30笔取一次
#直接加和给定时间点的回报率的平方，你就得到这个时间点的Realized Variance
#Realized Variance a.k.a. Integrated Variance

var_day = square_rtn.resample('1D').sum()
var_day = var_day.fillna(0)
#如果直接加和，年化了以后还是挺大的，可以说MicroStructure Noise是存在的。
var_day_ann = var_day*365
var_day_ann.plot()

#试着改善一下，稀疏采样。
var_day_s100 = square_rtn.resample('1D').apply(lambda x:sum(x[::100]))
var_day_s100_ann = var_day_s100*365
var_day_s100_ann.plot()

tick_day_count = log_rtn.resample('1D').count()
tick_day_count = tick_day_count.iloc[tick_day_count.nonzero()]
#只保留非0的笔数部分，算波动率。
#如果要年化，直接对方差乘上对应的时间刻度就好了，例如，日估计就乘上365这样。
vol_day_ann = pow(var_day.iloc[var_day.nonzero()]/tick_day_count*365,0.5)
vol_day_ann.plot()
