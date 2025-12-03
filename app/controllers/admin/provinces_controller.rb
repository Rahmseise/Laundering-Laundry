class Admin::ProvincesController < Admin::BaseController
  before_action :set_province, only: %i[edit update]

  def index
    @provinces = Province.order(:name)
  end

  def edit; end

  def update
    if @province.update(province_params)
      flash[:notice] = "Tax rates updated successfully!"
      redirect_to admin_provinces_path
    else
      flash.now[:alert] = "Error updating tax rates."
      render :edit, status: :unprocessable_content
    end
  end

  private

  def set_province
    @province = Province.find(params[:id])
  end

  def province_params
    params.expect(province: %i[gst_rate pst_rate hst_rate])
  end
end
