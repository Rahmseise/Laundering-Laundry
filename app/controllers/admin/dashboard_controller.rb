class Admin::DashboardController < Admin::BaseController
  def index
    @total_products = Product.count
    @total_orders = Order.count
    @total_customers = Customer.count
    @total_revenue = Order.paid.sum(:total)
    @recent_orders = Order.includes(:customer, :province).order(created_at: :desc).limit(10)
    @low_stock_products = Product.where(stock_quantity: ...10).order(:stock_quantity)
  end
end
