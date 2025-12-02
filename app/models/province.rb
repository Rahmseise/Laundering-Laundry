class Province < ApplicationRecord
  has_many :customers
  has_many :orders

  validates :name, presence: true
  validates :code, presence: true, uniqueness: true
  validates :gst_rate, :pst_rate, :hst_rate, numericality: { greater_than_or_equal_to: 0 }

  def total_tax_rate
    gst_rate + pst_rate + hst_rate
  end
end
