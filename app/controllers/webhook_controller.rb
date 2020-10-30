require 'line/bot'

class WebhookController < ApplicationController
  protect_from_forgery except: [:callback] # CSRF対策無効化

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def callback
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      head 470
    end

    events = client.parse_events_from(body)
    events.each { |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          begin
            items = RakutenService::Request.exec(event.message['text'])
            parsed_items = RakutenService::Parse.exec(items)
            reply_message = RakutenService::CreateMessage.exec(parsed_items)
          rescue RakutenWebService::WrongParameter => exception
            puts exception.inspect
            reply_message = ErrorMessageService::Create.exec("メッセージをお確かめの上、もう一度送信してください！\n（例: 「頭痛」「吐き気」「発熱」）")
          rescue ItemNotFoundError => exception
            puts exception
            reply_message = ErrorMessageService::Create.exec(exception.message)
          end
          client.reply_message(event['replyToken'], reply_message)
        when Line::Bot::Event::MessageType::Image, Line::Bot::Event::MessageType::Video
          response = client.get_message_content(event.message['id'])
          tf = Tempfile.open("content")
          tf.write(response.body)
        end
      end
    }
    head :ok
  end
end
