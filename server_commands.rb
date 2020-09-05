require 'open-uri'
require 'nokogiri'
require 'securerandom'
require 'digest'

class BaseCommand
  def self.run(args)
    raise NotImplementedError.new ('Not Implemented')
  end

  def self.get_name
    raise NotImplementedError.new ('Not Implemented')
  end

  def self.get_description
    raise NotImplementedError.new ('Not Implemented')
  end
end


class RandomCommand < BaseCommand
  def self.run(args='')
    rand(0...1000000)
  end

  def self.get_name
    'random'
  end

  def self.get_description
    'Return Random Value'
  end
end

class TimeNowCommand < BaseCommand
  def self.run(args='')
    Time.now.ctime
  end

  def self.get_name
    'timenow'
  end

  def self.get_description
    'Return Current Time'
  end
end

class ColorCommand < BaseCommand
  def self.run(args='')
    "#%06X" % (rand * 0xffffff)
  end

  def self.get_name
    'color'
  end

  def self.get_description
    'Return random color in hex'
  end
end

class UUidCommand < BaseCommand
  def self.run(args='')
    SecureRandom.uuid
  end

  def self.get_name
    'uuid'
  end

  def self.get_description
    'Return uuid'
  end
end

class MD5Command < BaseCommand
  def self.run(args='')
    Digest::MD5.hexdigest(args)
  end

  def self.get_name
    'md5'
  end

  def self.get_description
    'Return md5'
  end
end

class SHA256Command < BaseCommand
  def self.run(args='')
    Digest::SHA256.hexdigest(args)
  end

  def self.get_name
    'sha256'
  end

  def self.get_description
    'Return sha256'
  end
end

class ValuteCommand < BaseCommand
  def self.run(args='')
    get_currency_exchange(args)
  end

  def self.get_name
    'valute'
  end

  def self.get_description
    'Return Valute'
  end

  private_class_method def self.get_currency_exchange(currency)
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
    RandomCommand, TimeNowCommand,  ColorCommand, UUidCommand,  MD5Command,
    SHA256Command, ValuteCommand
]

def process_command(command_name, args='')
  ALL_COMMANDS.each do |command|
    return command.run(args) if command.get_name == command_name
  end
  return ValuteCommand.run("USD") if command_name == 'valute_USD'
  return "Unrecognized command '#{command_name}'"
end


if __FILE__ == $0 then
  puts RandomCommand.run

  puts process_command('valute_USD')
  puts process_command('valute_XYU')
  puts process_command('random')
  puts process_command('color')

end
