class Product < ApplicationRecord
  belongs_to :category
  has_many :order_items
  has_many :cart_items, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many_attached :images

  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :sku, presence: true, uniqueness: true
  validates :stock_quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :on_sale, -> { where(on_sale: true) }
  scope :new_products, -> { where(created_at: 3.days.ago..) }
  scope :recently_updated, -> { where('updated_at >= ? AND created_at < ?', 3.days.ago, 3.days.ago) }
  scope :in_stock, -> { where('stock_quantity > ?', 0) }

  def current_price
    on_sale? && sale_price.present? ? sale_price : price
  end

  def average_rating
    reviews.average(:rating).to_f.round(1)
  end
end
