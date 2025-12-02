class Admin::CategoriesController < Admin::BaseController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  def index
    @categories = Category.all.order(:name)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      flash[:notice] = "Category created successfully!"
      redirect_to admin_categories_path
    else
      flash.now[:alert] = "Error creating category."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      flash[:notice] = "Category updated successfully!"
      redirect_to admin_categories_path
    else
      flash.now[:alert] = "Error updating category."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @category.products.any?
      flash[:alert] = "Cannot delete category with products."
      redirect_to admin_categories_path
    else
      @category.destroy
      flash[:notice] = "Category deleted successfully!"
      redirect_to admin_categories_path
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :description, :image)
  end
end
