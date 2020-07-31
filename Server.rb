require 'socket'                 # Get sockets from stdlib
require 'securerandom'
require 'digest'
require 'open-uri'
require 'nokogiri'
require_relative 'common'



host = 'localhost'
# host = "127.0.0.1"
# host = "0.0.0.0"
port = 2000

def getCurrencyExchange(currency)
  url = "http://www.cbr.ru/scripts/XML_daily.asp"

  doc = Nokogiri::XML(URI.open(url))

  doc.css('Valute').each do |node|
    ccy = node.css('CharCode').text
    value = node.css('Value').text
    return value.sub(',', '.').to_f.round(2).to_s if ccy == currency
  end
  return ''
end

server = TCPServer.open(host, port)    # Socket to listen on port 2000
puts "Server is starting http://#{host}:#{port}"
loop {
  # begin
  #   raise MyCustomException.new "Message, message, message", "Yup"
  # rescue MyCustomException => e
  #   puts e.message # Message, message, message*
  #                  puts e.exception_type # Yup*
  # end
  client = server.accept # Wait for a client to connect
  _, remote_port, _, remote_ip = client.peeraddr

  puts "Client successfully connected #{remote_ip}:#{remote_port}"
  msg = recv_all(client)
  command, args = parse_command(msg)
  puts "Command: '#{command}', args: '#{args}'"

  rs = ''
  case command
  when 'random' then
    rs = rand(0...1000000)
  when 'timenow' then
    rs = Time.now.ctime
  when 'color' then
    rs = "#%06X" % (rand * 0xffffff)
  when 'uuid' then
    rs = SecureRandom.uuid
  when 'md5' then
    rs = Digest::MD5.hexdigest(args)
  when 'sha256' then
    rs = Digest::SHA256.hexdigest(args)
  when 'valute' then
    rs = getCurrencyExchange(args)
  when 'valute_USD' then
    rs = getCurrencyExchange('USD')
  else
    rs = "Unrecognized command '#{command}'"
    puts rs
  end

  send_all(client, rs)

  client.close
  puts "Client is disconnected"
  puts "\n"
}

