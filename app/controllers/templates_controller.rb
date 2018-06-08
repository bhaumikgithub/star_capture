class TemplatesController < ApplicationController

  include InheritAction 

  private

  def resource_params
    params.require(:template).permit!
  end
end
