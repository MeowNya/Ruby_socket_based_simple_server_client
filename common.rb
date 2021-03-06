def recv_all(s)
  begin
    raw_msg_len = s.read(8).unpack('Q').first # Unpack is 8 byte to number
    return s.read(raw_msg_len)
  rescue
    return ''
  end
end

def send_all(s, msg)
  begin
    msg = msg.to_s
    s.write [msg.length].pack('Q') + msg # Q is 8 byte (long long int)
  rescue
    return
  end
end

def parse_command(msg)
  command = msg[0..9].rstrip
  args = msg[10..]
  return command, args
end

def merge_command(command, args)
  if args.nil?
    args = ''
  end
  return command.ljust(10) + args
end