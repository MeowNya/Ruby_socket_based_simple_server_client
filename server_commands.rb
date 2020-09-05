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

class SHA256Command < BaseCommand
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

ALL_COMMANDS = [
    RandomCommand.new, TimeNowCommand.new,  ColorCommand.new, UUidCommand.new,  MD5Command.new,
    SHA256Command.new, ValuteCommand.new
]

def process_command(command_name, args='')
  ALL_COMMANDS.each do |command|
    return command.run(args) if command.get_name == command_name
  end
  return ValuteCommand.new.run("USD") if command_name == 'valute_USD'
  return "Unrecognized command '#{command_name}'"
end


if __FILE__ == $0 then
  command = RandomCommand.new
  puts command.run

  puts process_command('valute_USD')
  puts process_command('valute_XYU')
  puts process_command('random')
  puts process_command('color')

end
