class Review < ApplicationRecord
  # Зв'язок багато до одного з користувачем
  belongs_to :user
  validates :rating, presence: true, inclusion: { in: 1..5 }
  belongs_to :restaurant, class_name: 'RestaurantsList', foreign_key: 'restaurant_id'
end
