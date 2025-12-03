class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :province
  has_many :order_items, dependent: :destroy

  enum :status, { pending: 0, paid: 1, shipped: 2, delivered: 3, cancelled: 4 }

  validates :total, :subtotal, :tax_amount, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  # Add scopes for each status
  scope :pending, -> { where(status: :pending) }
  scope :paid, -> { where(status: :paid) }
  scope :shipped, -> { where(status: :shipped) }
  scope :delivered, -> { where(status: :delivered) }
  scope :cancelled, -> { where(status: :cancelled) }

  before_validation :set_default_status, on: :create
  before_save :calculate_totals

  def set_default_status
    self.status = :pending if status.nil?
  end

  def calculate_totals
    return unless order_items.loaded? || order_items.any?

    self.subtotal = order_items.sum { |item| item.price * item.quantity }
    self.tax_amount = subtotal * (province.total_tax_rate / 100)
    self.total = subtotal + tax_amount
  end
end
