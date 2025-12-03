class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_customer_profile

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
    @subtotal = @cart_items.sum(&:subtotal)
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

    # Calculate totals
    subtotal = @cart_items.sum(&:subtotal)
    tax_amount = subtotal * (@customer.province.total_tax_rate / 100)
    total = subtotal + tax_amount

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

      # Process Stripe payment
      begin
        charge = Stripe::Charge.create(
          amount: (total * 100).to_i, # Convert to cents
          currency: 'cad',
          description: "Order ##{@order.id} - #{@customer.full_name}",
          source: params[:stripeToken],
          metadata: {
            order_id: @order.id,
            customer_email: current_user.email
          }
        )

        # Save payment ID and mark as paid
        @order.update!(
          status: :paid,
          payment_id: charge.id
        )

        # Clear cart
        @cart_items.destroy_all

        flash[:notice] = "Order placed successfully! Payment confirmed."
        redirect_to order_path(@order)
      rescue Stripe::CardError => e
        @order.destroy # Remove the order if payment fails
        flash[:alert] = "Payment failed: #{e.message}"
        redirect_to new_order_path
      end
    end
  rescue StandardError => e
    flash[:alert] = "Error processing order: #{e.message}"
    redirect_to new_order_path
  end

  private

  def ensure_customer_profile
    return if current_user.customer.present?

    flash[:alert] = "Please complete your profile before placing orders."
    redirect_to new_profile_path
  end

  def order_params
    params.expect(order: [:shipping_address]) if params[:order].present?
  end
end
