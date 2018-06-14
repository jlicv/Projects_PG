# -*- coding: utf-8 -*-
"""
Created on Wed Nov 15 10:10:35 2017

@author: Jason Li
"""



import pandas as pd
import sqlite3 as sl
#import numpy as np

conn = sl.connect('C:/Fall2017-HKUST/Independt Project- Dr. Chou Hongsong/DataSet/Datebase/btc_cny.db')
#Avg_Tick_Count_ByTickDifference
q_amt = """SELECT amount FROM trades"""    
q_timestamp = """SELECT time,amount FROM trades"""
df_timestamp = pd.read_sql_query(q_timestamp,conn,parse_dates='time')

#如果不把时间先重新拍一遍，会出现很奇怪的结果
#其他的数据也要试试！
#The results seems weird! Why there are -1day + 35 seconds such things?
df_timestamp = df_timestamp.sort_values(by=['time'],ascending=True)
df_timestamp['delta'] = df_timestamp.time.diff().fillna(0)
#取出时间点以后，看看笔间时间差
time_df_tick = df_timestamp['delta'].value_counts()
#挑出最大的时间差的笔数，检查异常的时间差。
time_df_tick = time_df_tick.sort_index(ascending=True)
time_df_tick = time_df_tick[time_df_tick.index < pd.Timedelta('2min')]
time_df_tick = time_df_tick[time_df_tick.index > pd.Timedelta('2s')]
time_df_tick.plot(kind='bar',fontsize= 6.5)
#10号，11到13号的Tick数据都是有缺失的。
#甭管了，先做吧。
time_df_tick.to_csv('timediff-tick-count.csv')