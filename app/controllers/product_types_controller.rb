class ProductTypesController < ApplicationController
  include InheritAction 

  private

  def resource_params
    params.require(:product_type).permit!
  end
end
