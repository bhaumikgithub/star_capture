# frozen_string_literal: true

class ProductTypesController < ApplicationController
  include InheritAction 
  load_and_authorize_resource
  private

  def resource_params
    params.require(:product_type).permit!
  end
end
