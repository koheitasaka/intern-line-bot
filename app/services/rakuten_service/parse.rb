module RakutenService
  class Parse
    include Service

    MAX_ITEM_COUNT = 5

    def initialize(items)
      @items = items
    end

    def exec
      parse_item(@items)
    end

    private

    def parse_item(items)
      items.first(MAX_ITEM_COUNT).map do |item|
        {
          name: item['itemName'],
          price: item['itemPrice'],
          itemUrl: item['itemUrl'],
        }
      end
    end
  end
end
