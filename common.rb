def recv_all(s)
  raw_msg_len = s.read(8).unpack('Q').first # Unpack is 8 byte to number
  return s.read(raw_msg_len)
end

def send_all(s, msg)
  msg = msg.to_s
  s.write [msg.length].pack('Q') + msg # Q is 8 byte (long long int)
end

