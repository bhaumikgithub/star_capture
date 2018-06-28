class ProductTypesController < ApplicationController
  include InheritAction 
  load_and_authorize_resource
end
