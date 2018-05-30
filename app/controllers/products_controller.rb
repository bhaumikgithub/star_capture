class ProductsController < ApplicationController

  include InheritAction
  
  private

  def resource_params
    params.require(:product).permit(:name, :price,:images => [], :category_ids => [])
  end

end
