class ProductsController < ApplicationController

  include InheritAction

  def delete_image
    puts @resource.inspect
    @resource.images.where(id: params[:image_id]).purge
    redirect_to product_path(@resource)
  end

  private

  def resource_params
    params.require(:product).permit(:name, :price,:images => [], :category_ids => [])
  end

end
