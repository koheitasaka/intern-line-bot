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
        "#{item['itemName']}, ¥#{item.price} \n #{item['itemUrl']} \n"
      end
      return parsed_items.join()
    end
  end
end