class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @products = @category.products.in_stock
                         .order(created_at: :desc)
                         .page(params[:page])
                         .per(12)
  end
end
