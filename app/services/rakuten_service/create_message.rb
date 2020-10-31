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
      medicines = items.map do | item |
        "#{item[:name]}, ¥#{item[:price]} \n #{item[:itemUrl]} \n"
      end
      {
        type: 'text',
        text: "こちらの薬がおすすめです！\n\n#{medicines.join()}"
      }
    end
  end
end
