class CategoriesController < ApplicationController

  include InheritAction

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
