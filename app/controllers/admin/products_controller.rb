class Admin::ProductsController < Admin::BaseController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.includes(:category)
                      .order(created_at: :desc)
                      .page(params[:page])
                      .per(20)

    if params[:search].present?
      @products = @products.where('name ILIKE ? OR description ILIKE ?',
                                 "%#{params[:search]}%",
                                 "%#{params[:search]}%")
    end

    if params[:category_id].present?
      @products = @products.where(category_id: params[:category_id])
    end
  end

  def show
  end

  def new
    @product = Product.new
    @categories = Category.all
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      flash[:notice] = "Product created successfully!"
      redirect_to admin_products_path
    else
      @categories = Category.all
      flash.now[:alert] = "Error creating product."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @categories = Category.all
  end

  def update
    if @product.update(product_params)
      flash[:notice] = "Product updated successfully!"
      redirect_to admin_product_path(@product)
    else
      @categories = Category.all
      flash.now[:alert] = "Error updating product."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    flash[:notice] = "Product deleted successfully!"
    redirect_to admin_products_path
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(
      :name, :description, :price, :sale_price, :on_sale,
      :sku, :stock_quantity, :category_id, images: []
    )
  end
end
