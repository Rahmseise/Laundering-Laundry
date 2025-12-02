class Admin::OrdersController < Admin::BaseController
  before_action :set_order, only: [:show, :update_status]

  def index
    @orders = Order.includes(:customer, :province)
                   .order(created_at: :desc)
                   .page(params[:page])
                   .per(20)

    if params[:status].present?
      @orders = @orders.where(status: params[:status])
    end
  end

  def show
    @order_items = @order.order_items.includes(:product)
  end

  def update_status
    if @order.update(status: params[:status])
      flash[:notice] = "Order status updated to #{params[:status]}!"
      redirect_to admin_order_path(@order)
    else
      flash[:alert] = "Error updating order status."
      redirect_to admin_order_path(@order)
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end
end