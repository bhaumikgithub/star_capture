class Ability
  include CanCan::Ability

  def initialize(user)
    if user.admin?
      can :manage, :all
    else
      can :show_nearby_products, Product
      can :update_user_location, Product
      can :read, Product
    end
  end
end
