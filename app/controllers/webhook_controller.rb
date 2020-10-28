require 'line/bot'

class WebhookController < ApplicationController
  protect_from_forgery except: [:callback] # CSRF対策無効化
  
  GENLE_ID = 558736 ## 定数の切り出し方のベストプラクティス的なものがわからないので一旦ベタに書く

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
            items = RakutenWebService::Ichiba::Item.search(keyword: event.message['text'], genreId: GENLE_ID, sort: '-reviewAverage')
            medicines = items.first(5).map do |item|
              "#{item['itemName']}, ¥#{item.price} \n #{item['itemUrl']} \n"
            end
            message['text'] = items.first(5).inject("症状:「#{event.message['text']}」にはこちらの薬がおすすめです！\n\n") do |result, item|
              result + "#{item['itemName']}, ¥#{item.price} \n #{item['itemUrl']} \n"
            end
          rescue => exception
            puts exception
            message['text'] = "もう一度症状を送ってください！（例: 「頭痛」「吐き気」「発熱」）"
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
