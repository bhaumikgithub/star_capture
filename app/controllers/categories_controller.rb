class CategoriesController < ApplicationController

  include InheritAction
  private

  def resource_params
    params.require(:category).permit(:name)
  end

end
