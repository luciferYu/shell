#!/usr/bin/python3
# -*- coding:utf-8 -*-
#auth:zhiyi
import random
'''下面我们就用具体的数字来实践一下RSA的密钥对生成
加密以及解密的过程，不过用很大的数计算起来会很困难
因此我们用较小的数模拟一下
密文 = 明文^E mod N (RSA 加密)
明文 = 密文^D mod N (RSA 解密)
'''

def get_prime(num):
    '''求1到num之间的质数'''
    plist = []
    for j in range(3,num):
        for i in range(2,j):
            if (j % i) == 0:
                break
        else:
            plist.append(j)
    return plist

def lcm(x,y):
    '''求最小公倍数'''
    if x > y:
        greater = x
    else:
        greater = y

    while True:
        if((greater % x == 0) and (greater % y == 0)):
            lcm = greater
            break
        greater += 1

    return lcm

def hcf(x,y):
    '''返回两个数的最大公约数'''
    if x > y:
        smaller = y
    else:
        smaller = x
    hcf = None
    for i in range(1,smaller+1):
        if((x % i == 0) and  (y % i ==0)):
            hcf = i
    return hcf

def gcd(num):
    '''求出和num最大公约数为1的数字列表'''
    list1 = []
    for i in range(2,num):
        if hcf(i,num) == 1:
            list1.append(i)
    return list1



if __name__ == '__main__':
    p_list = get_prime(500)
    print('质数列表%s' % get_prime(500))

    # 密钥对生成
    # 1.求N 首先我们准备两个质数p、q，这里我们选择17和19，他们都是质数
    p = random.choice(p_list)
    q = random.choice(p_list)
    while True:  #防止p和q相等
        if p == q:
            q = random.choice(p_list)
        else:
            break

    print('p = %d' % p)
    print('q = %d' % q)
    # p = 17
    # q = 19
    N = p * q  # 323

    print('N = %d' % N)

    # 2.求L L是p-1和q-1的最小公倍数
    L = lcm(p-1,q-1) # 144


    #3.求E E和L的最大公约数必须是1
    E_list = gcd(L) # [5, 7, 11, 13, 17, 19, 23, 25, 29, 31, 35, 37, ...] 这些数成为和L互质的数
    print('可以用于作为密钥的E的列表：%s' % E_list)
    E = random.choice(E_list) # 随机产生E

    #4.求D
    D = None
    for d_num in E_list:
        if (E * d_num) % L == 1:
            D = d_num
            break

    #此时已经得到了公钥与私钥
    print('公钥是（E = %d,N = %d）' % (E, N))   #公钥是（E = 113,N = 323）
    print('私钥是（D = %d,N = %d）' % (D, N))  # 私钥是（D = 65,N = 323）

    #明文
    msg = 'hello python'

    #5 加密  注意要加密的明文必须是小于N的数 因为加密运算要求mod N
    # 公式为 明文^E mod N
    E_list = []
    for c in msg:
        E_list.append(ord(c) ** E % N)

    print(E_list)  # [206, 271, 261, 261, 213, 185, 85, 213, 114, 261, 66]
    Es = ''
    for num in E_list:
        Es += chr(num)

    print('加密的密文是:  (%s)' % Es)

    #6 解密
    # 公式为 明文^D mod N
    Dstr = ''
    for num in E_list:
        Dstr += (chr(num ** D % N))
    print('解密的明文是:  %s'%Dstr)  # hello world








