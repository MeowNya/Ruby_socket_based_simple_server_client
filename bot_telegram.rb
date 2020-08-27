require 'telegram/bot'
require_relative 'config'
require_relative 'Client'


Telegram::Bot::Client.run(API_TOKEN) do |bot|
  bot.listen do |message|
    begin
      puts "On message: " + message.text

      case message.text
      when '/start'
        text = "Hello, #{message.from.first_name}"
      else
        command, args = message.text.split(' ', 2)
        text = send_command(command, args)
      end

      bot.api.send_message(chat_id: message.chat.id, text: text)

    rescue
      # TODO: логитрование
      # TODO: задержку
      bot.api.send_message(chat_id: message.chat.id, text: ERROR_TEXT)
    end
  end
end
