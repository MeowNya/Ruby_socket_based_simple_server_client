# class Server_commands
# end

def get_currency_exchange(currency)
  url = "http://www.cbr.ru/scripts/XML_daily.asp"

  doc = Nokogiri::XML(URI.open(url))

  doc.css('Valute').each do |node|
    ccy = node.css('CharCode').text
    value = node.css('Value').text
    return value.sub(',', '.').to_f.round(2).to_s if ccy == currency
  end
  return "Not found currency #{currency}"
end


def process_command(command, args)
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
    rs = get_currency_exchange(args)
  when 'valute_USD' then
    rs = get_currency_exchange('USD')
  else
    rs = "Unrecognized command '#{command}'"
  end
  return rs
end
