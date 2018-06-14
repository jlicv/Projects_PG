# -*- coding: utf-8 -*-
"""
Created on Wed Oct 25 15:37:19 2017

@author: Jason Li
"""

import pandas as pd
import sqlite3 as sl
import numpy as np
#import datetime as datetime
#一下子就读出df了，方便快捷！
#写简单的SQL就做完了，而且很快！真好！
conn = sl.connect('C:/Fall2017-HKUST/Independt Project- Dr. Chou Hongsong/DataSet/Datebase/btc_cny.db')
q = """SELECT time, 
    (CASE 
        WHEN sum(amount)=0 THEN null 
        ELSE sum(amount*price)/sum(amount)
    END) as weighted_price,
    sum(amount) as amount
    FROM trades 
    GROUP BY time"""
df = pd.read_sql_query(q,conn,parse_dates='time')
df['log_rtn'] = np.log(df.weighted_price) - np.log(df.weighted_price.shift(1))
df = df.fillna(0)
df = df.drop(['weighted_price'],axis=1)    
df = df.drop(['amount'],axis=1)

q_amt = """SELECT amount FROM trades"""    
q_timestamp = """SELECT time,amount FROM trades"""
df_timestamp = pd.read_sql_query(q_timestamp,conn,parse_dates='time')
df_timestamp['delta'] = (df_timestamp['time'] - df_timestamp['time'].shift()).fillna(0)
#取出时间点以后，看看笔间时间差
df_timestamp['delta'].value_counts()
#10号，11到13号的Tick数据都是有缺失的。
#甭管了，先做吧。
df_timestamp.sort_values(by='delta',ascending=False).head()

def Var_TwoScale(tick_interval):
    rlzd_var_all = df['log_rtn'].var()
    rlzd_var_estm = np.zeros((tick_interval,))
    nbar = np.zeros((tick_interval,))
    for i in range(0,tick_interval):
        nbar[i] = df[df.index % tick_interval == i].shape[0]
        rlzd_var_estm[i] = df[df.index % tick_interval == i].var()
    var_twoscale = rlzd_var_estm.mean()-sum(nbar)/tick_interval*rlzd_var_all
    return var_twoscale
#Tick_interval refers to n_{bar};
#Number of bins refers to K;
#We have n_{bar}*K = n, where n_{bar} assumed to be 
#We have a series of scaling factors, ranging from A to B, to see which might
    #be the good estimate;
    
Var_estm = pd.DataFrame(columns=['tick_interval','Var_TwoScale'])
Var_estm['tick_interval'] = range(10,300,20)
Var_estm['Var_TwoScale'] = 0.000
for i in range(0,Var_estm.shape[0]):   
    Var_estm['Var_TwoScale'][i] = Var_TwoScale(Var_estm['tick_interval'][i])
#你这么做哪里来Two-Scale的味道了啊？蛤？
#df.set_index('time').resample('120S',loffset=time_offset,base=bracket.index[0].second).last()
#Now we need to obtain the log rtn
#Be careful, the timing between each yield has different length of time, implying that when you annualized the yield,
#You just simply add up the rtn over a given period of time to obtain the so-called annulaized return.
#smpl_ital = str(sample_interval,'S')
#ts = pd.Series(df.log_rtn, index=df.index)
#ts_5th_estimator = ts.std()
#tick_interval = 120

#反序一下，从后面往前面走，
#问题出在asFreq这个参数上啊
#ts.resample('1Min', label='left', loffset='50s')
#df.set_index('time',inplace =True)
#df.index = np.datetime64(df.index).astype(datetime)
#df['sampled'] = 0
#times = 0
#rlzd_vol = 0
#df = df[0:1000]

#df.resample('120S').agg(lambda x:x.std())
#head = df.loc[df.sampled==0].index[0]
#follow = df.loc[df.sampled==0].index[1]
#bracket = df[head:head+pd.Timedelta(sample_interval,unit='s')]
#time_offset = bracket.index[13] - bracket.index[0]
#Resample函数有Bug，还是没法处理Datetime64类型的时候出现loffset的情况。Github上似乎还没有解决这个问题。
#有没有办法从bracket那一行的时间点开始呢？
#即使时间点是对的，但是结果也有问题。


#while(bracket.loc[bracket.sampled==0].shape[0]!=0):    
#    pts = df.resample(str(sample_interval)+'S',base=pd.Timedelta(bracket.index[times]-time_offset).seconds).asfreq()
#    pts = pts.dropna(axis=0) 
#    df.loc[pts.index,'sampled']=1
#    pts = pts[pts.sampled.values!=1] 
#    rlzd_vol = rlzd_vol+pts['log_rtn'].std()
#    times = times + 1

#Think carefully, either you do it by modulus of row
#Or do it by modulus of timing, which should be correct?

#tstring = datetime.strptime(str(df.time),"%Y-%m-%d %H:%M:%S")
#ts = datetime.strptime(pd.Series.dt.strftime(df.time,"%Y-%m-%d %H:%M:%S"),"%Y-%m-%d %H:%M:%S")
#pd.Series.dt.strftime(df.time,"%Y-%m-%d %H:%M:%S")
#df_copy = df.copy()
#df_copy['sampled'] = 0
#I want to check the box-plot of the log return, to see if there is any outliners;
#df.boxplot(['log_rtn'])
#Seemingly OK, might be a few sharp change within a few seconds;
#----------------------------------------------------#
#
#
#
#----------------------------------------------------#
#Interval: The sample interval;
#Period: Daily/Weekly/
#rtn: dataframe with time and return
#每一个df都有一个index的，可以用来找行号
#
#def Rlzd_vol_estm(interval,period,rtn):
#    rtn['sampled'] = 0
#    head = rtn.loc[1]
#    tail = rtn.loc[2]
#    if(head['sampled']==0)
