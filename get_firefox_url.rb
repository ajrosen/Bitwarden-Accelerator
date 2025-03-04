#!/usr/bin/ruby

require 'socket'

# RPC payload to get current tab info from alfred-firefox
#
#   . del etx soh soh bel   R   e   q   u   e   s   t soh del nul
# nul soh stx soh  cr   S   e   r   v   i   c   e   M   e   t   h
#   o   d soh  ff nul soh etx   S   e   q soh ack nul nul nul dle
# del nul soh  vt   F   i   r   e   f   o   x   .   T   a   b nul
# etx eot nul nul

# Sample response for about:blank
#
#   : del soh etx soh soh  bs   R   e   s   p   o   n   s   e soh
# del stx nul soh etx soh  cr   S   e   r   v   i   c   e   M   e
#   t   h   o   d soh  ff nul soh etx   S   e   q soh ack nul soh
# enq   E   r   r   o   r soh  ff nul nul nul dle del stx soh  vt
#   F   i   r   e   f   o   x   .   T   a   b nul   L del etx etx
# soh soh etx   T   a   b soh del eot nul soh ack soh stx   I   D
# soh eot nul soh  bs   W   i   n   d   o   w   I   D soh eot nul
# soh enq   I   n   d   e   x soh eot nul soh enq   T   i   t   l
#   e soh  ff nul soh etx   U   R   L soh  ff nul soh ack   A   c
#   t   i   v   e soh stx nul nul nul   " del eot soh del  bs soh
# ack soh   4 soh bel   N   e   w  sp   T   a   b soh  vt   a   b
#   o   u   t   :   b   l   a   n   k soh soh nul

payload = ".\x7F\x03\x01\x01"
payload << "\aRequest\x01\xFF\x80\x00\x01\x02\x01"
payload << "\rServiceMethod\x01\f\x00\x01"
payload << "\x03Seq\x01\x06\x00\x00\x00\x10\xFF\x80\x01"
payload << "\vFirefox.Tab\x00\x03\x04\x00\x00"

# Send the payload
socket = UNIXSocket.new("/tmp/alfred-firefox.#{Process.euid}.sock")
socket.send(payload, 0)

# Read the response
response = socket.recvfrom(3000)

# Going backwards, get the characters between the second and third SOH
url = ''
soh = 0

response[0].split('').reverse.each do |c|
  if c == 1.chr
    soh += 1
  elsif soh == 2
    url << c
  end

  break if soh == 3
end

# Print the result
puts url.reverse[1 + (url.length / 256)..]
