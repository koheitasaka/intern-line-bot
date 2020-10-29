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
      return "症状:「#{message}」にはこちらの薬がおすすめです！\n\n#{items}"
    end
  end
end