module ErrorMessageService
  class Create
    include Service

    MAX_ITEM_COUNT = 5

    def initialize(message)
      @message = message
    end

    def exec
      {
        type: 'text',
        text: @message
      }
    end
  end
end
