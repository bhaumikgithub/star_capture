# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?


  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to current_user.admin? ? root_path : products_path , notice: exception.message }
    end
  end

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end

  protected

  def after_sign_in_path_for(resource)
    if resource.role == 'admin'
      root_path
    else
      show_nearby_products_products_path
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

end
