class RestaurantsList < ApplicationRecord
  has_many :reviews, foreign_key: :restaurant_id
  attr_accessor :image_base64

  def self.search(name: nil, city: nil, category: nil)
    results = self.all
    results = results.where("name LIKE ?", "%#{name}%") if name.present?
    results = results.where("city LIKE ?", "%#{city}%") if city.present?
    results = results.where("category LIKE ?", "%#{category}%") if category.present?
    results
  end
end