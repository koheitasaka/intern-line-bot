module RakutenService
  class Parse
    include Service

    def initialize(items)
      @items = items
    end

    def exec
      parsed_items = parse_item(@items)
      return parsed_items
    end

    private

    def parse_item(items)
      parsed_items = items.first(5).map do |item|
        {
          name: item['itemName'],
          price: item['itemPrice'],
          url: item['itemUrl'],
          imageUrl: item['mediumImageUrls'][0],
        }
      end
      return parsed_items
    end
  end
end
