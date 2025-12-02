class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_admin
  before_action :set_customer, only: [:show, :edit, :update]

  def show
  end

  def new
    @customer = current_user.build_customer
    @provinces = Province.all
  end

  def create
    @customer = current_user.build_customer(customer_params)

    if @customer.save
      flash[:notice] = "Profile created successfully!"
      redirect_to profile_path
    else
      @provinces = Province.all
      flash.now[:alert] = "Error creating profile."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @provinces = Province.all
  end

  def update
    if @customer.update(customer_params)
      flash[:notice] = "Profile updated successfully!"
      redirect_to profile_path
    else
      @provinces = Province.all
      flash.now[:alert] = "Error updating profile."
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def redirect_if_admin
    if current_user.admin?
      flash[:alert] = "Admin users don't have customer profiles."
      redirect_to admin_root_path
    end
  end

  def set_customer
    @customer = current_user.customer || current_user.build_customer
  end

  def customer_params
    params.require(:customer).permit(
      :first_name, :last_name, :phone,
      :address, :city, :province_id, :postal_code
    )
  end
end