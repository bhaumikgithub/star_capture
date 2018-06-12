class CategoryTemplatesController < ApplicationController

  include InheritAction 

  private

  def resource_params
    params.require(:category_template).permit!
  end
end
