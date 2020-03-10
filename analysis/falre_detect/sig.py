#!/usr/bin/env python
# coding: utf-8

# In[28]:


import numpy as np
import pandas as pd
import linecache as line
import sys

args = sys.argv

file = args[2]
data = pd.read_csv(file, delim_whitespace=True, header=None)
z1 = data[0]
z2 = data[2]
z3 = data[3]
z4 = data[4]
a1 = len(z2)
a = 1
sig = float(args[1])


with open("flux_sig.txt",mode='a') as ave:
    with open("error_sig.txt",mode='a') as ave1:

        while a <= a1:

            b2 = float(z2[a-1])
            b3 = str(z3[a-1])
            b4  =float(z4[a-1])
            b = b2 - b4
            
            if b < sig:
                print(z1[a-1],b2,b4,b,sig,"NO")
                x = str(b2)
                ave.write(x)
                ave.write('\n')
                ave1.write(b3)
                ave1.write('\n')
                a = a + 1
            
            else:
                print(z1[a-1],b2,b4,b,sig,"flare!")
                x1 = "Nan"
                ave.write(x1)
                ave.write('\n')
                x2 = "NULL"
                ave1.write(x2)
                ave1.write('\n')
                a = a + 1
        


line.clearcache()






