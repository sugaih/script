#2020/03/04
#okamoto
#移動平均をとるスクリプト
#python boxcar.py 区間数 inputfile outputfile loopnum

import numpy as np
import pandas as pd
import linecache as line
import sys
args = sys.argv

loopnum = args[4]
n = args[1] #区間数の設定
k = int(n) // 2
a = int(n) % 2 #奇数or偶数の判定
file = args[2] #移動平均をとるfile
output = args[3]

data = pd.read_csv(file, delim_whitespace=True, header=None)
z1 = data[0]
l = len(z1)
i = 0



with open(output,mode='a') as b:
    while i+1 <= k:
        print(loopnum,"周目",i+1)
        x = "Nan"
        b.write(x)
        b.write('\n')
        i = i + 1


    while k < i+1 <= l-k:
        print(loopnum,"周目",i+1)
        if str(z1[i]) in "Nan":
            x = "Nan"
            b.write(x)
            b.write('\n')
            i = i + 1

        else:
            if a == 1:  
                j = i - k 
                mylist = [0]

                while j < i+k+1:
                    mylist.append(float(z1[j]))
                    j = j + 1

                mylist.pop(0)
                data = pd.DataFrame(mylist)
                count = data.count()[0]

                if count == 0:
                    x = "Nan"
                    b.write(x)
                    b.write('\n')
                    i = i + 1

                else:
                    data.sum()[0]
                    ave = sum / count
                    x = str(ave)
                    b.write(x)
                    b.write('\n')
                    i = i + 1

            if a == 0:  
                j = i - k
                mylist1 = [0]
                while j < i+k:
                    mylist1.append(float(z1[j]))
                    j = j + 1
            
                mylist1.pop(0)
                data1 = pd.DataFrame(mylist1)
                count1 = data1.count()[0]

                h = i + 1 - k
                mylist2 = [0]
                while h < i+1+k:
                    mylist2.append(float(z1[h]))
                    h = h + 1
            
                mylist2.pop(0)
                data2 = pd.DataFrame(mylist2)
                count1 = data2.count()[0]

                if count1 == 0 and count2 == 0:
                    x = "Nan"
                    b.write(x)
                    b.write('\n')
                    i = i + 1

                else:
                    sum1 = data1.sum()[0]
                    ave1 = sum1 / count1
                    sum2 = data2.sum()[0]
                    ave2 = sum2 / data2.count()[0]
                    ave = (ave1 + ave2) / 2
                    x = str(ave)
                    b.write(x)
                    b.write('\n')
                    i = i + 1

    while l-k < i+1 <= l:
        print(loopnum,"周目",i+1)
        x = "Nan"
        b.write(x)
        b.write('\n')
        i = i + 1