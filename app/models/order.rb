class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :province
  has_many :order_items, dependent: :destroy

  enum :status, { pending: 0, paid: 1, shipped: 2, delivered: 3, cancelled: 4 }, default: :pending

  validates :status, presence: true
  validates :total, :subtotal, :tax_amount, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  before_save :calculate_totals

  def calculate_totals
    return unless order_items.loaded? || order_items.any?

    self.subtotal = order_items.sum { |item| item.price * item.quantity }
    self.tax_amount = subtotal * (province.total_tax_rate / 100)
    self.total = subtotal + tax_amount
  end
end
