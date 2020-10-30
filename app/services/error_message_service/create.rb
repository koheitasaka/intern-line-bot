module ErrorMessageService
  class Create
    include Service

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
