class Medicine
  include ActiveModel::Model
  
  attr_accessor :name, :price, :url, :image_url

  validates :name, presence: true
  validates :price, presence: true
  validates :url, presence: true
  validates :image_url, presence: true
  validates :url, format: /\A#{URI::regexp(%w(http https))}\z/
  
  def initialize(response_item)
    @name = response_item[:name]
    @price = response_item[:price]
    @url = response_item[:url]
    @image_url = response_item[:imageUrl]
  end
end
