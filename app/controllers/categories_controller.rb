class CategoriesController < ApplicationController

  include InheritAction

  def index
    # @resources = Category.all.order('created_at DESC').page(params[:page]).per(10)
    @resources = Category.left_outer_joins(:products).includes(:category_template).select("categories.*, COUNT(products.*) as product_count").group('categories.id').order('created_at DESC').page(params[:page]).per(10)
  end

  def delete_category_with_products
    products = @resource.products
    products.each do |product|
      product.destroy if product.categories.count == 1
    end
    @resource.destroy
    redirect_to categories_path
  end

  private

  def resource_params
    params.require(:category).permit(:name, :category_template_id)
  end

end
