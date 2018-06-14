# -*- coding: utf-8 -*-
"""
Created on Wed Oct 25 15:37:19 2017

@author: Jason Li
"""

import pandas as pd
import sqlite3 as sl
import numpy as np

#import datetime as datetime

conn = sl.connect('C:/Fall2017-HKUST/Independt Project- Dr. Chou Hongsong/DataSet/Datebase/btc_cny.db')
q = """SELECT time,price,amount
    FROM trades 
    """
df = pd.read_sql_query(q,conn,parse_dates='time')
df['log_rtn'] = np.log(df.price) - np.log(df.price.shift(1))
df = df.fillna(0)
df = df.drop(['price','amount'],axis=1)    
#按照天数统计笔数
n_Tick_Count_Hour = df.groupby(df['time'].map(lambda x:x.day*24+x.hour)).agg(['count'])
#能不能再按照每5分钟切分呢？
#并不需要，实际上笔数的分布，按天看，并不均匀。
#制作一个数组，存放各个K和n_bar的数值。
n = pd.DataFrame.mean(n_Tick_Count_Hour).loc['time'].values
K_initial = pow(n,2/3.0)
nbar_initial = n/K_initial
K_series = pd.Series(np.arange(0.5,10,0.5))*K_initial
nbar_series = n/K_series
TwoScale_Parameters = pd.DataFrame(K_series.astype('int'),columns=['K'])
TwoScale_Parameters['nbar'] = nbar_series.astype('int')
Var_alltick = df.groupby(df['time'].map(lambda x:x.day)).std()

#制作第一层Index，按天数划分
index_day = df['time'].map(lambda x:x.day).values
#制作存放结果的表头,index被后来的结果定义为天数
Estm = pd.DataFrame(columns=['log_rtn','K'])
#每一天里面Tick对应的哪个i，i从1到K；
for i in range(TwoScale_Parameters.shape[0]):    
    #制作第二层Index，按照K的值
    index_K = df.index.map(lambda x:x%TwoScale_Parameters.loc[i,'K']).values
    #制作一个两层的Index，第一层是index_day，第二层是index_Bin.
    index = pd.MultiIndex.from_arrays([index_day,index_K],names=['day','K'])
    #根据这个Index计算各组的方差
    Var_slice = df.groupby(index).std()
    #把Index重新制作成MultiIndex
    Var_slice.index = pd.MultiIndex.from_tuples(Var_slice.index,names=['day','K'])
    #这下子就可以算日内RV的均值了！
    #发现用Python解锁了做透视表的技能，开心~！
    Var_pool = Var_slice.mean(level='day')
    #做一点点变换，就得到Two Scale RV的按日估计了。
    #这里加一个极小的量是为了确保nbar/n这个量不会丢失精度。
    Var_TwoScale = Var_pool - TwoScale_Parameters.loc[i,'nbar']/(n+1e-10)*Var_alltick
    Var_TwoScale['K'] = TwoScale_Parameters.loc[i,'K']
    Estm = Estm.append(Var_TwoScale)
#Notice that the index has been silently change when you write to csv.
Estm.to_csv('Daily_TwoScale_Hour.csv')