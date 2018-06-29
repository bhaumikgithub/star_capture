# frozen_string_literal: true

class UsersController < ApplicationController

  before_action :get_client , only: [:create_travellers,:show]
  
  def new
    @resource = User.new
  end

  def create
    @resource = User.new(user_params)
    client_password = Devise.friendly_token.first(6)
    @resource.name = user_params[:name]+'@'+client_password
    @resource.role = 'client'
    @resource.password = client_password
    @resource.operator_id = current_user.id
    if  @resource.save
      redirect_to @resource
    else
      render 'new'
    end
  end

  def index
    @resources = User.where(role: 'client').page(params[:page]).per(10)
  end

  def destroy
    User.find(params[:id]).destroy
    redirect_to users_path
  end

  def create_travellers
    @resource.update(user_params)
    redirect_to @resource
  end

  private

  def get_client
    @resource = User.find_by_id(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email,:phone_number,travellers_attributes: [:first_name,:last_name,:gender,:birthdate,:id,:_destroy])
  end
end
