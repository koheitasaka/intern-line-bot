class Medicine
  include ActiveModel::Model
  
  attr_accessor :name, :price, :url

  validates :name, :price, :url, presence: true
  validates :url, format: /\A#{URI::regexp(%w(http https))}\z/
  
  def initialize(response_item)
    @name = nil
    @price = response_item[:price]
    @url = response_item[:itemUrl]
  end
end