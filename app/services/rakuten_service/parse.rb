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
        medicine = Medicine.new(
          item['itemName'],
          item['itemPrice'],
          item['itemUrl'],
          item['mediumImageUrls'][0],
        )
        raise ResponseError if medicine.invalid?
        medicine
      end
    end
  end
end
