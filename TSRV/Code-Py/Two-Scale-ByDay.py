# -*- coding: utf-8 -*-
"""
Created on Thu Nov 23 09:59:39 2017

@author: Jason Li
"""
import pandas as pd
import numpy as np
log_rtn = pd.Series.from_csv('log_rtn.csv')
square_rtn = log_rtn**2
n_tick = log_rtn.resample('1D').count()
#对应Zhang,MykLand(2005)里面的Fifth Estimator，直接根据Tick的数据，求RV。
var_all = square_rtn.resample('1D').sum()
#对应Zhang,Mykland(2005)里面的Fourth Estimator，稀疏采样，求RV。
#::40，意思是每隔40个Tick抽一个点。
#你可以不年化先。比较完以后再一起年化。
var_45_sparse = square_rtn.resample('1D').apply(lambda x:sum(x[::20]))
var_45_sparse.name = 'sparse:every 20 tick'
var_all = var_all.fillna(0)
cumsum_n_tick = np.cumsum(n_tick)
#一开始选择的是0到第一次Resample对应的行，所以要加多一行到cumsum_n_tick
extrarow_cumsum = cumsum_n_tick[0:1]
extrarow_cumsum = extrarow_cumsum.shift(freq='-1D')
extrarow_cumsum[0] = 0
cumsum_n_tick = extrarow_cumsum.append(cumsum_n_tick)
two_scale_var = pd.Series()
for i in range(0,len(cumsum_n_tick)-1):
    series = square_rtn[cumsum_n_tick[i]:cumsum_n_tick[i+1]]
    series.index = range(0,len(series))
    n = len(series)
    K_initial = pow(n,2/3.0)
    if(n!=0):
        nbar_initial = n/K_initial
        index_K = series.index.map(lambda x:x%int(K_initial)).values
        var_slice = series.groupby(index_K).std()
        var_TwoScale = var_slice.sum() - nbar_initial/(n+1e-8)*var_all[i]
    else:
        var_TwoScale = 0
    two_scale_var = two_scale_var.append(pd.Series(var_TwoScale))
two_scale_var.index = var_all.index
two_scale_var.name = 'two_scale'
var_all.name = 'realized var'
var_df = pd.concat([two_scale_var,var_all,var_45_sparse],axis=1)
var_df.plot()
var_df_ann = var_df * 365
var_df_ann.plot()
var_df.to_csv('var-twoestimates-1D.csv')