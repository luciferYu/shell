#!/usr/bin/python3
# -*- coding:utf-8 -*-
#auth:zhiyi
'''
本文简单的演示了利用cryptography库
使用rsa算法进行数字签名和加密解密的过程
这个库的详细文档参看官方网站  https://cryptography.io/en/latest/
关于RSA参看wiki百科 https://en.wikipedia.org/wiki/RSA_(cryptosystem)#Key_generation
'''




#key loading
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import serialization
with open("prikey", "rb") as key_file:
    private_key = serialization.load_pem_private_key(
            key_file.read(),
            password=None,
            backend=default_backend()
        )

#Key serialization
pem = private_key.private_bytes(
    encoding=serialization.Encoding.PEM,
    #加密密钥
    #format=serialization.PrivateFormat.PKCS8,
    #encryption_algorithm=serialization.BestAvailableEncryption(b'mypassword')
    #未加密密钥
    format=serialization.PrivateFormat.TraditionalOpenSSL,
    encryption_algorithm=serialization.NoEncryption()
    )

# 测试打印密钥第一行
print(pem.splitlines()[0])


#数字签名
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.asymmetric import padding
message = b"A message I want to sign"
signature = private_key.sign(
     message,
     padding.PSS(
         mgf=padding.MGF1(hashes.SHA256()),
         salt_length=padding.PSS.MAX_LENGTH
     ),
     hashes.SHA256()
 )

print('使用私钥签名后的信息')
print(signature)

#验证签名  验证签名需要你公钥,签名，还有消息
#如果消息比对成功，则不会报错，如果消息比对失败，则会抛出raise InvalidSignature 异常
from cryptography.exceptions import InvalidSignature
public_key = private_key.public_key()
try:
    public_key.verify(
         signature,
         message, #b"A message I want to sign",
         padding.PSS(
             mgf=padding.MGF1(hashes.SHA256()),
             salt_length=padding.PSS.MAX_LENGTH
         ),
         hashes.SHA256()
    )
    print('签名认证成功')
except InvalidSignature:
    print('签名认证失败')




# #If your data is too large to be passed in a single call, you can hash it separately and pass that value using Prehashed.
# #如果签名的内容过长使用一下方法
# from cryptography.hazmat.primitives.asymmetric import utils
# chosen_hash = hashes.SHA256()
# hasher = hashes.Hash(chosen_hash, default_backend())
# hasher.update(b"data & ")
# hasher.update(b"more data")
# digest = hasher.finalize()
# sig = private_key.sign(
#      digest,
#      padding.PSS(
#          mgf=padding.MGF1(hashes.SHA256()),
#          salt_length=padding.PSS.MAX_LENGTH
#      ),
#      utils.Prehashed(chosen_hash)
#  )
# #验证过长的内容数字签名
# chosen_hash = hashes.SHA256()
# hasher = hashes.Hash(chosen_hash, default_backend())
# hasher.update(b"data & ")
# hasher.update(b"more data")
# digest = hasher.finalize()
# public_key.verify(
#      sig,
#      digest,
#      padding.PSS(
#          mgf=padding.MGF1(hashes.SHA256()),
#          salt_length=padding.PSS.MAX_LENGTH
#      ),
#      utils.Prehashed(chosen_hash)
#  )

#加密
with open("sshpubkey", "rb") as pkey_file:
    public_key = serialization.load_ssh_public_key(
            pkey_file.read(),
            backend=default_backend()
        )
message = b"encrypted data"
ciphertext = public_key.encrypt(
     message,
     padding.OAEP(
         mgf=padding.MGF1(algorithm=hashes.SHA1()),
         algorithm=hashes.SHA1(),
         label=None
     )
 )
print('加密后的信息：%s'% ciphertext)
#解密
plaintext = private_key.decrypt(
    ciphertext,
     padding.OAEP(
         mgf=padding.MGF1(algorithm=hashes.SHA1()),
         algorithm=hashes.SHA1(),
         label=None
     )
 )
print('解密后的信息:%s'%plaintext)


from cryptography.hazmat.primitives.asymmetric import rsa
if __name__ == '__main__':
    pass