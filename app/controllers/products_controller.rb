class ProductsController < ApplicationController
  def index
    @products = Product.includes(:category).in_stock

    # Search functionality
    if params[:search].present?
      @products = @products.where('name ILIKE ? OR description ILIKE ?',
                                  "%#{params[:search]}%",
                                  "%#{params[:search]}%")
    end

    # Filter by category
    @products = @products.where(category_id: params[:category_id]) if params[:category_id].present?

    # Filter options
    case params[:filter]
    when 'on_sale'
      @products = @products.on_sale
    when 'new'
      @products = @products.new_products
    when 'recently_updated'
      @products = @products.recently_updated
    end

    @products = @products.order(created_at: :desc).page(params[:page]).per(12)
    @categories = Category.all
  end

  def show
    @product = Product.includes(:category, :reviews).find(params[:id])
    @related_products = @product.category.products
                                .where.not(id: @product.id)
                                .limit(4)
  end
end
