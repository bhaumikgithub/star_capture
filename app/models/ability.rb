# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    if user.admin?
      can :manage, :all
    else
      can :show_nearby_products, Product
      can :update_user_location, Product
      can :create_product_comments, Product
      can :load_more_comments, Product
      can :read, Product
      can :liked_by_user, Product
      can :delete_product_comment, Product
      can :create, User
      can :read, User
      can :manage, TransportType
    end
  end
end
