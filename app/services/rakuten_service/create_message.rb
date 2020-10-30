module RakutenService
  class CreateMessage
    include Service

    def initialize(items)
      @items = items
    end

    def exec
      create_message(@items)
    end

    private

    def create_message(items)
      columns = items.map do | item |
        {
          "thumbnailImageUrl": item.image_url,
          "imageBackgroundColor": "#FFFFFF",
          "title": "#{item.name.slice(0,30)}...",
          "text": "¥#{item.price}\n#{item.name}",
          "defaultAction": {
            "type": "uri",
            "label": "商品ページへ",
            "uri": item.url
          },
          "actions": [
            {
              "type": "uri",
              "label": "商品ページへ",
              "uri": item.url
            }
          ]
        }
      end
      {
        "type": "template",
        "altText": "こちらの薬がおすすめです！",
        "template": {
          "type": "carousel",
          "columns": columns,
          "imageAspectRatio": "rectangle",
          "imageSize": "cover"
        }
      }
    end
  end
end
