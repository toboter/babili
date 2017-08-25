class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    cannot :manage, :all
    can :read, :all
    cannot :read, Doorkeeper::Application

    if user.is_active == true
      # can :manage, :all

      cannot :manage, Project unless user.is_admin == true
      can [:edit, :update, :destroy], Project do |project|
        user.in?(project.members) && project.memberships.where(user_id: user.id).first.role.in?(['Owner', 'Admin'])
      end
      can [:read, :new, :create], Project

      cannot :manage, Oread::Application unless user.is_admin == true
      can [:update, :destroy], Oread::Application do |app|
        app.owner == user
      end
      can [:read, :create], Oread::Application
  

      cannot :manage, Doorkeeper::Application unless user.is_admin == true
      can :manage, OauthAccessibility, oauth_application: { owner: user }

    else
      

    end

    can :manage, User if user.is_admin == true
    cannot :index, User unless user.is_admin == true
    can [:show, :create, :update, :destroy], User do |u|
      u == user
    end
    can [:create, :update, :edit, :new], Profile do |p|
      p.user == user
    end

  end
end