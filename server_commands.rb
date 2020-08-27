require 'open-uri'
require 'nokogiri'
require 'securerandom'
require 'digest'

class BaseCommand
  def run(args)
    raise NotImplementedError.new ('Not Implemented')
  end

  def get_name
    raise NotImplementedError.new ('Not Implemented')
  end

  def get_description
    raise NotImplementedError.new ('Not Implemented')
  end
end



class RandomCommand < BaseCommand
  def run(args='')
    rand(0...1000000)
  end

  def get_name
    'random'
  end

  def get_description
    'Return Random Value'
  end
end

class TimeNowCommand < BaseCommand
  def run(args='')
    Time.now.ctime
  end

  def get_name
    'timenow'
  end

  def get_description
    'Return Current Time'
  end
end

class ColorCommand < BaseCommand
  def run(args='')
    "#%06X" % (rand * 0xffffff)
  end

  def get_name
    'color'
  end

  def get_description
    'Return random color in hex'
  end
end

class UUidCommand < BaseCommand
  def run(args='')
    SecureRandom.uuid
  end

  def get_name
    'uuid'
  end

  def get_description
    'Return uuid'
  end
end

class MD5Command < BaseCommand
  def run(args='')
    Digest::MD5.hexdigest(args)
  end

  def get_name
    'md5'
  end

  def get_description
    'Return md5'
  end
end

class SHA254Command < BaseCommand
  def run(args='')
    Digest::SHA256.hexdigest(args)
  end

  def get_name
    'sha256'
  end

  def get_description
    'Return sha256'
  end
end

class ValuteCommand < BaseCommand
  def run(args='')
    get_currency_exchange(args)
  end

  def get_name
    'valute'
  end

  def get_description
    'Return Valute'
  end

  private def get_currency_exchange(currency)
    url = "http://www.cbr.ru/scripts/XML_daily.asp"

    doc = Nokogiri::XML(URI.open(url))

    doc.css('Valute').each do |node|
      ccy = node.css('CharCode').text
      value = node.css('Value').text
      return value.sub(',', '.').to_f.round(2).to_s if ccy == currency
    end
    return "Not found currency #{currency}"
  end
end


def process_command(command, args)
  rs = ''
  case command
  when 'random' then
    rs = RandomCommand.new.run(0...1000000)
  when 'timenow' then
    rs = TimeNowCommand.new.run
  when 'color' then
    rs = ColorCommand.new.run
  when 'uuid' then
    rs = UUidCommand.new.run
  when 'md5' then
    rs = MD5Command.new.run(args)
  when 'sha256' then
    rs = SHA254Command.new.run(args)
  when 'valute' then
    rs = ValuteCommand.new.run(args)
  when 'valute_USD' then
    rs = ValuteCommand.new.run('USD')
  else
    rs = "Unrecognized command '#{command}'"
  end
  return rs
end


if __FILE__ == $0 then
  command = RandomCommand.new
  puts command.run
end
