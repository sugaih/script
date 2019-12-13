#!/usr/bin/env python
# coding: utf-8

# In[1]:


import numpy as np
import pandas as pd
import linecache as line
import sys

args = sys.argv

file = open("flux.txt","r")
data = file.read().split()
output = args[1]
m = args[2]
y = ['Nan' if i == 'NULL' else  i for i in data]
a1 = len(y)
print(a1)
with open(output,mode='a') as ave:
    a = 1
    a2 = a1 - 50
    nan1 = 'nan'
    nan2 = float(nan1)
    
    while a <= a1:
    
        if a <= 50:
            x="Nan"
            ave.write(x)
            ave.write('\n')
            print(m,a,a1)
            a = a + 1
            
        elif 50 < a <= a2:
            b50 = float(y[a-51])
            b49 = float(y[a-50])
            b48 = float(y[a-49])
            b47 = float(y[a-48])
            b46 = float(y[a-47])
            b45 = float(y[a-46])
            b44 = float(y[a-45])
            b43 = float(y[a-44])
            b42 = float(y[a-43])
            b41 = float(y[a-42])
            b40 = float(y[a-41])
            b39 = float(y[a-40])
            b38 = float(y[a-39])
            b37 = float(y[a-38])
            b36 = float(y[a-37])
            b35 = float(y[a-36])
            b34 = float(y[a-35])
            b33 = float(y[a-34])
            b32 = float(y[a-33])
            b31 = float(y[a-32])
            b30 = float(y[a-31])
            b29 = float(y[a-30])
            b28 = float(y[a-29])
            b27 = float(y[a-28])
            b26 = float(y[a-27])
            b25 = float(y[a-26])
            b24 = float(y[a-25])
            b23 = float(y[a-24])
            b22 = float(y[a-23])
            b21 = float(y[a-22])
            b20 = float(y[a-21])
            b19 = float(y[a-20])
            b18 = float(y[a-19])
            b17 = float(y[a-18])
            b16 = float(y[a-17])
            b15 = float(y[a-16])
            b14 = float(y[a-15])
            b13 = float(y[a-14])
            b12 = float(y[a-13])
            b11 = float(y[a-12])
            b10 = float(y[a-11])
            b9 = float(y[a-10])
            b8 = float(y[a-9])
            b7 = float(y[a-8])
            b6 = float(y[a-7])
            b5 = float(y[a-6])
            b4 = float(y[a-5])
            b3 = float(y[a-4])
            b2 = float(y[a-3])
            b1 = float(y[a-2])
            i1 = float(y[a-1])
            i2 = y[a-1]
            c1 = float(y[a])
            c2 = float(y[a+1])
            c3 = float(y[a+2])
            c4 = float(y[a+3])
            c5 = float(y[a+4])
            c6 = float(y[a+5])
            c7 = float(y[a+6])
            c8 = float(y[a+7])
            c9 = float(y[a+8])
            c10 = float(y[a+9])
            c11 = float(y[a+10])
            c12 = float(y[a+11])
            c13 = float(y[a+12])
            c14 = float(y[a+13])
            c15 = float(y[a+14])
            c16 = float(y[a+15])
            c17 = float(y[a+16])
            c18 = float(y[a+17])
            c19 = float(y[a+18])
            c20 = float(y[a+19])
            c21 = float(y[a+20])
            c22 = float(y[a+21])
            c23 = float(y[a+22])
            c24 = float(y[a+23])
            c25 = float(y[a+24])
            c26 = float(y[a+25])
            c27 = float(y[a+26])
            c28 = float(y[a+27])
            c29 = float(y[a+28])
            c30 = float(y[a+29])
            c31 = float(y[a+30])
            c32 = float(y[a+31])
            c33 = float(y[a+32])
            c34 = float(y[a+33])
            c35 = float(y[a+34])
            c36 = float(y[a+35])
            c37 = float(y[a+36])
            c38 = float(y[a+37])
            c39 = float(y[a+38])
            c40 = float(y[a+39])
            c41 = float(y[a+40])
            c42 = float(y[a+41])
            c43 = float(y[a+42])
            c44 = float(y[a+43])
            c45 = float(y[a+44])
            c46 = float(y[a+45])
            c47 = float(y[a+46])
            c48 = float(y[a+47])
            c49 = float(y[a+48])
            c50 = float(y[a+49])
            
            if i2 in "Nan":
                x="Nan"
                ave.write(x)
                ave.write('\n')
                print(m,a,a1)
                a = a + 1
        
            else:
                d1 = pd.DataFrame([b50,b49,b48,b47,b46,b45,b44,b43,b42,b41,b40,b39,b38,b37,b36,b35,b34,b33,b32,b31,b30,b29,b28,b27,b26,b25,b24,b23,b22,b21,b20,b19,b18,b17,b16,b15,b14,b13,b12,b11,b10,b9,b8,b7,b6,b5,b4,b3,b2,b1,i1,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16,c17,c18,c19,c20,c21,c22,c23,c24,c25,c26,c27,c28,c29,c30,c31,c32,c33,c34,c35,c36,c37,c38,c39,c40,c41,c42,c43,c44,c45,c46,c47,c48,c49])
                d2 = pd.DataFrame([b49,b48,b47,b46,b45,b44,b43,b42,b41,b40,b39,b38,b37,b36,b35,b34,b33,b32,b31,b30,b29,b28,b27,b26,b25,b24,b23,b22,b21,b20,b19,b18,b17,b16,b15,b14,b13,b12,b11,b10,b9,b8,b7,b6,b5,b4,b3,b2,b1,i1,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16,c17,c18,c19,c20,c21,c22,c23,c24,c25,c26,c27,c28,c29,c30,c31,c32,c33,c34,c35,c36,c37,c38,c39,c40,c41,c42,c43,c44,c45,c46,c47,c48,c49,c50])
                count1 = d1.count()[0]
                count2 = d2.count()[0]
                
                
                if count1 == 0 and count2 == 0:
                    x="Nan"
                    ave.write(x)
                    ave.write('\n')
                    print(m,a,a1)
                    a = a + 1
                
                else:
                    sum1 = d1.sum()[0]
                    mean1 = sum1 / count1
                    sum2 = d2.sum()[0]
                    mean2  =sum2 / count2
                    x3 = (mean1 + mean2)/2
                    x = str(x3)
                    ave.write(x)
                    ave.write('\n')
                    print(m,a,a1)
                    a = a + 1
        
        elif a2 < a <= a1:
            x="Nan"
            ave.write(x)
            ave.write('\n')
            print(m,a,a1)
            
            if a == a1:
                print("finish")
                a = a + 1
        
            else:
                a = a + 1
            
line.clearcache()


# In[ ]:




