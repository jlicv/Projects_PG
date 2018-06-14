# -*- coding: utf-8 -*-
"""
Created on Sun Oct 29 05:00:58 2017

@author: Jason Li
"""
import pandas as pd
import numpy as np

rng = pd.date_range('1/1/2012', periods=100, freq='S')
ts = pd.Series(np.random.randint(0, 500, len(rng)), index=rng)
#问题出在afFreq这个参数上面呀
ts.resample('1Min', label='left', loffset='50s').std()
pd.DataFrame.resample('1Min',loffset='50s')
