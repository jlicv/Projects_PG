# -*- coding: utf-8 -*-
"""
Created on Tue Nov 21 21:29:54 2017

@author: Jason Li
"""




import pandas as pd
import numpy as np
log_rtn = pd.Series.from_csv('log_rtn.csv')
square_rtn = log_rtn**2

var_45min = square_rtn.resample('45min').sum()
var_45min = var_45min.fillna(0)
var_45min.plot()

var_30min = square_rtn.resample('30min').sum()
var_30min = var_30min.fillna(0)
var_30min.plot()