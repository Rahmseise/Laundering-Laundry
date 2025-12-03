class Admin::CustomersController < Admin::BaseController
  def index
    @customers = Customer.includes(:user, :province)
                         .order(created_at: :desc)
                         .page(params[:page])
                         .per(20)
  end

  def show
    @customer = Customer.find(params[:id])
    @orders = @customer.orders.order(created_at: :desc)
  end
end
