class Customer < ApplicationRecord
  belongs_to :user
  belongs_to :province, optional: true
  has_many :orders, dependent: :destroy

  validates :first_name, :last_name, presence: true
  validates :phone, format: { with: /\A\d{10,}\z/, message: "must be at least 10 digits" }, allow_blank: true
  validates :postal_code, format: { with: /\A[A-Za-z]\d[A-Za-z] ?\d[A-Za-z]\d\z/, message: "must be valid Canadian postal code" }, allow_blank: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def full_address
    parts = [address, city]
    parts << province.name if province.present?
    parts << postal_code
    parts.compact.join(', ')
  end
end