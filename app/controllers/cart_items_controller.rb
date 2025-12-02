class CartItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart_item, only: [:update, :destroy]

  def create
    @product = Product.find(params[:product_id])
    @cart_item = current_user.cart_items.find_or_initialize_by(product: @product)

    if @cart_item.new_record?
      @cart_item.quantity = params[:quantity] || 1
    else
      @cart_item.quantity += (params[:quantity] || 1).to_i
    end

    if @cart_item.save
      flash[:notice] = "#{@product.name} added to cart!"
      redirect_to cart_path
    else
      flash[:alert] = "Error adding to cart."
      redirect_to product_path(@product)
    end
  end

  def update
    if @cart_item.update(quantity: params[:quantity])
      redirect_to cart_path, notice: 'Cart updated!'
    else
      redirect_to cart_path, alert: 'Error updating cart.'
    end
  end

  def destroy
    @cart_item.destroy
    redirect_to cart_path, notice: 'Item removed from cart.'
  end

  private

  def set_cart_item
    @cart_item = current_user.cart_items.find(params[:id])
  end
end
