class UsersController < ApplicationController

  def new
    @resource = User.new
  end

  def create
    @resource = User.new(user_params)
    client_password = Devise.friendly_token.first(6)
    @resource.name = user_params[:name]+'@'+client_password
    @resource.role = 'client'
    @resource.password = client_password 
    if  @resource.save
      redirect_to users_path
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

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
