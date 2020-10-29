module RakutenService
  class Request
    include Service
    
    GENRE_ID = 558736

    def initialize(message)
      @message = message
    end

    def exec
      items = RakutenWebService::Ichiba::Item.search(keyword: @message, genreId: GENRE_ID, sort: '-reviewAverage')
      check_items_size(items)
      return items
    end

    private

    def check_items_size(items)
      if items.count == 0
        return ItemNotFoundError.new("該当する医薬品が見つかりませんでした。\n もう一度送信内容を確かめてみてください！\n（例: 「頭痛」「吐き気」「発熱」）")
      end
    end
  end
end