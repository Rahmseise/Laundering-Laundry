class Review < ApplicationRecord
  belongs_to :product
  belongs_to :user

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :comment, presence: true, length: { minimum: 10 }
  validates :user_id, uniqueness: { scope: :product_id, message: "can only review a product once" }
end
