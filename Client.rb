require 'socket'
require_relative 'common'

def send_command(command, args='')
  hostname = 'localhost'
  port = 2000

  s = TCPSocket.open(hostname, port)
  msg = merge_command(command, args)
  send_all(s, msg)
  rs = recv_all(s)
  puts rs
  s.close

  return rs
end


if __FILE__ == $0 then
  send_command('random')
  send_command('random')
  send_command('color')
  send_command('color')
  send_command('color')
  send_command('timenow')
  send_command('uuid')
  send_command('md5', '0123456')
  send_command('sha256', '0123456')
  send_command('valute_USD')
  send_command('valute','USD')
  send_command('valute', 'EUR')
end
