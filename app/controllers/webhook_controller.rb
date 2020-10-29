require 'line/bot'

class WebhookController < ApplicationController
  protect_from_forgery except: [:callback] # CSRF対策無効化
  
  GENRE_ID = 558736

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
          message = {
            type: 'text',
          }
          begin
            items = RakutenWebService::Ichiba::Item.search(keyword: event.message['text'], genreId: GENRE_ID, sort: '-reviewAverage')
            checkResponseSize(items)
            message['text'] = parseResponse(items, "症状:「#{event.message['text']}」にはこちらの薬がおすすめです！\n\n")
          rescue RakutenWebService::WrongParameter => exception
            puts exception.inspect
            message['text'] = "メッセージをお確かめの上、もう一度送信してください！\n（例: 「頭痛」「吐き気」「発熱」）"
          rescue ItemNotFoundError => exception
            puts exception
            message['text'] = exception.message
          end
          client.reply_message(event['replyToken'], message)
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

private

def checkResponseSize(response)
  if response.count == 0
    raise ItemNotFoundError.new("該当する医薬品が見つかりませんでした。\n もう一度送信内容を確かめてみてください！\n（例: 「頭痛」「吐き気」「発熱」）")
  end
end

def parseResponse(response, message)
  return response.first(5).inject(message) do |result, item|
    result + "#{item['itemName']}, ¥#{item.price} \n #{item['itemUrl']} \n"
  end
end
