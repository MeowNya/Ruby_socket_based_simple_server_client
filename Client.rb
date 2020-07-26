require 'socket'
require_relative 'common'

def send_comm(command)
  hostname = 'localhost'
  port = 2000

  s = TCPSocket.open(hostname, port)
  send_all(s, command)
  puts recv_all(s)
  s.close
end

send_comm('random')
send_comm('random')
send_comm('color')
send_comm('color')
send_comm('color')
send_comm('timenow')
send_comm('uuid')
