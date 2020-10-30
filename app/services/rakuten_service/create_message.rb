module RakutenService
  class CreateMessage
    include Service

    def initialize(medicines)
      @medicines = medicines
    end

    def exec
      create_message(@medicines)
    end

    private

    def create_message(medicines)
      columns = medicines.map do | medicine |
        {
          "thumbnailImageUrl": medicine.image_url,
          "imageBackgroundColor": "#FFFFFF",
          "title": "#{medicine.name.slice(0,30)}...",
          "text": "¥#{medicine.price}\n#{medicine.name}",
          "defaultAction": {
            "type": "uri",
            "label": "商品ページへ",
            "uri": medicine.url
          },
          "actions": [
            {
              "type": "uri",
              "label": "商品ページへ",
              "uri": medicine.url
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
