#!/usr/bin/python3
# -*- coding:utf-8 -*-
#auth:zhiyi
#本文演示了最简单的AES 对称加密解密

import os
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.backends import default_backend
backend = default_backend()
key = os.urandom(32)  # 生成随机密钥
print('密钥%s'%key)
iv = os.urandom(16)
cipher = Cipher(algorithms.AES(key), modes.CBC(iv), backend=backend)
encryptor = cipher.encryptor()
ct = encryptor.update(b"a secret message") + encryptor.finalize() #测试下来消息必须是固定长度 b"a secret message"
decryptor = cipher.decryptor()
print('解密后的密文:%s'% str(decryptor.update(ct) + decryptor.finalize()))





if __name__ == '__main__':
    pass