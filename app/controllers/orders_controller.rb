
class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_customer_profile, only: [:new, :create]

  def index
    @orders = current_user.customer.orders.order(created_at: :desc)
  end

  def show
    @order = current_user.customer.orders.find(params[:id])
    @order_items = @order.order_items.includes(:product)
  end

  def new
    @cart_items = current_user.cart_items.includes(:product)

    if @cart_items.empty?
      redirect_to cart_path, alert: 'Your cart is empty.'
      return
    end

    @customer = current_user.customer
    @order = Order.new(customer: @customer, province: @customer.province)
    @subtotal = @cart_items.sum { |item| item.subtotal }
    @tax_amount = @subtotal * (@customer.province.total_tax_rate / 100)
    @total = @subtotal + @tax_amount
  end

  def create
    @customer = current_user.customer
    @cart_items = current_user.cart_items.includes(:product)

    if @cart_items.empty?
      redirect_to cart_path, alert: 'Your cart is empty.'
      return
    end

    # Create order
    @order = Order.new(
      customer: @customer,
      province: @customer.province,
      status: :pending,
      shipping_address: order_params[:shipping_address] || @customer.full_address
    )

    ActiveRecord::Base.transaction do
      @order.save!

      # Create order items from cart
      @cart_items.each do |cart_item|
        OrderItem.create!(
          order: @order,
          product: cart_item.product,
          quantity: cart_item.quantity,
          price: cart_item.product.current_price,
          product_name: cart_item.product.name
        )
      end

      # Calculate totals
      @order.calculate_totals
      @order.save!

      # Process payment (placeholder - integrate Stripe here)
      # payment_result = process_stripe_payment(@order)

      # For now, mark as paid
      @order.update!(status: :paid)

      # Clear cart
      @cart_items.destroy_all

      flash[:notice] = "Order placed successfully!"
      redirect_to order_path(@order)
    end
  rescue => e
    flash[:alert] = "Error processing order: #{e.message}"
    redirect_to new_order_path
  end

  private

  def ensure_customer_profile
    unless current_user.customer.present?
      flash[:alert] = "Please complete your profile before placing an order."
      redirect_to new_profile_path
    end
  end

  def order_params
    params.require(:order).permit(:shipping_address)
  end
end
