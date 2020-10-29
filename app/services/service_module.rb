module Service
  extend ActiveSupport::Concern
  class_methods do
    def exec(*args)
      service = new(*args)
      service.exec
    end
  end
end