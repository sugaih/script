#!/usr/bin/env python
# coding: utf-8


import numpy as np
import pandas as pd
from scipy import interpolate
import matplotlib.pyplot as plt
import sys



args = sys.argv

def spline(x,y,point):
    f = interpolate.Akima1DInterpolator(x, y)
    X = np.linspace(x[0],x[-1],num=point,endpoint=True)
    Y = f(X)
    return X,Y


file = args[1]
save1 = args[3]
save2 = args[4]
data = pd.read_csv(file, delim_whitespace=True, header=None)
m = args[2]


x = data[0]
y = data[2]


x = x.values
y = y.values
a,b = spline(x,y,m)


plt.plot(x, y, 'ro',label="controlpoint")
plt.plot(a,b,label="Akima1DInterpolator")


np.savetxt(save1, a, fmt ='%.6f')
np.savetxt(save2, b, fmt ='%.6f')

