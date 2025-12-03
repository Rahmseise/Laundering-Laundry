class CartsController < ApplicationController
  before_action :authenticate_user!

  def show
    @cart_items = current_user.cart_items.includes(:product)
    @subtotal = @cart_items.sum(&:subtotal)
  end
end
