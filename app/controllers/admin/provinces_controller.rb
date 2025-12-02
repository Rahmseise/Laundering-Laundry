class Admin::ProvincesController < Admin::BaseController
  before_action :set_province, only: [:edit, :update]

  def index
    @provinces = Province.all.order(:name)
  end

  def edit
  end

  def update
    if @province.update(province_params)
      flash[:notice] = "Tax rates updated successfully!"
      redirect_to admin_provinces_path
    else
      flash.now[:alert] = "Error updating tax rates."
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_province
    @province = Province.find(params[:id])
  end

  def province_params
    params.require(:province).permit(:gst_rate, :pst_rate, :hst_rate)
  end
end