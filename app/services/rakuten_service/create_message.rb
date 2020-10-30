module RakutenService
  class CreateMessage
    include Service

    def initialize(message, items)
      @message = message
      @items = items
    end

    def exec
      reply_message = create_message(@message, @items)
      return reply_message
    end

    private

    def create_message(message, items)
      medicines = items.map do | item |
        "#{item[:name]}, ¥#{item[:price]} \n #{item[:itemUrl]} \n"
      end
      return "症状:「#{message}」にはこちらの薬がおすすめです！\n\n#{medicines.join()}"
    end
  end
end
