class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :customer, dependent: :destroy
  has_many :cart_items, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :orders, through: :customer

  enum :role, { customer: 0, admin: 1 }, default: :customer

  after_initialize :set_default_role, if: :new_record?

  def set_default_role
    self.role ||= :customer
  end
end
