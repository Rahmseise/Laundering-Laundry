class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :product_name, presence: true

  before_validation :set_product_details

  private

  def set_product_details
    if product.present?
      self.price ||= product.current_price
      self.product_name ||= product.name
    end
  end
end