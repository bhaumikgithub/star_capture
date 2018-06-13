class CategoryTemplatesController < ApplicationController

  include InheritAction 

  def index
    @resources = CategoryTemplate.includes(:category).order('created_at DESC').page(params[:page]).per(10)
  end

  private

  def resource_params
    params.require(:category_template).permit!
  end
end
