class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    cannot :manage, :all
    can :read, :all
    cannot :read, Doorkeeper::Application

    if user.is_active == true
      can :manage, :all

      cannot :manage, Project unless user.is_admin == true
      cannot :manage, Membership unless user.is_admin == true
      can [:update, :destroy], Project do |project|
        user.in?(project.members) && project.memberships.where(user_id: user.id).first.role.in?(['Owner', 'Admin'])
      end
      can :manage, Membership do |membership|
        membership.project.members.include?(user) && membership.project.memberships.where(user_id: user.id).first.role.in?(['Owner', 'Admin'])
      end
      can [:read, :create], Project
      can :read, Membership


      cannot :manage, Oread::Application unless user.is_admin == true
      cannot :manage, OreadAccessibility unless user.is_admin == true
      can [:update, :destroy], Oread::Application do |app|
        app.owner == user
      end
      can :manage, OreadAccessibility, oread_application: { :owner_id => user.id }
      can [:read, :create], Oread::Application
      can :read, OreadAccessibility


      cannot :manage, Doorkeeper::Application unless user.is_admin == true
      

    else
      

    end

    can :manage, User if user.is_admin == true
    cannot :index, User unless user.is_admin == true
    can [:show, :create, :update, :destroy], User do |u|
      u == user
    end

  end
end