class Request
  include Service

  def initialize(message)
    @message = message
  end

  def exec
    items = RakutenWebService::Ichiba::Item.search(keyword: @message, genreId: GENRE_ID, sort: '-reviewAverage')
    check_items_size(items)
    parsed_items = parse_item(items)
    reply_message = create_message(message, parsed_items)
    return reply_message
  end

  private

  def check_items_size(items)
    if items.count == 0
      return ItemNotFoundError.new("該当する医薬品が見つかりませんでした。\n もう一度送信内容を確かめてみてください！\n（例: 「頭痛」「吐き気」「発熱」）")
    end
  end

  def parse_item(items)
    parsed_items = items.first(5).map do |item|
      "#{item['itemName']}, ¥#{item.price} \n #{item['itemUrl']} \n"
    end
    return parsed_items.join()
  end

  def create_message(message, items)
    return "症状:「#{message}」にはこちらの薬がおすすめです！\n\n#{items}"
  end
end
