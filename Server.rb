require 'socket'                 # Get sockets from stdlib
require_relative 'common'
require_relative 'server_commands'


host = 'localhost'
# host = "127.0.0.1"
# host = "0.0.0.0"
port = 2000

server = TCPServer.open(host, port)    # Socket to listen on port 2000
puts "Server is starting http://#{host}:#{port}"
loop do
  # TODO: ловить исключения

  # begin
  #   raise MyCustomException.new "Message, message, message", "Yup"
  # rescue MyCustomException => e
  #   puts e.message # Message, message, message*
  #                  puts e.exception_type # Yup*
  # end
  Thread.start(server.accept) do |client|
    _, remote_port, _, remote_ip = client.peeraddr

    puts "Client successfully connected #{remote_ip}:#{remote_port}"
    msg = recv_all(client)
    command, args = parse_command(msg)
    puts "Command: '#{command}', args: '#{args}'"

    # if command == 'color' then
    #   sleep 5
    # end

    rs = process_command(command, args)
    puts "Response: #{rs}"
    send_all(client, rs)

    client.close
    puts 'Client is disconnected'
    puts "\n"
  end
end
