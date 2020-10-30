class Medicine
  include ActiveModel::Model
  
  attr_accessor :name, :price, :url, :image_url

  validates :name, presence: true
  validates :price, presence: true
  validates :url, presence: true
  validates :url, format: /\A#{URI::regexp(%w(http https))}\z/
  
  def initialize(name, price, url, image_url)
    @name = name
    @price = price
    @url = url
    @image_url = image_url
  end
end
