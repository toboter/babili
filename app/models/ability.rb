class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    cannot :manage, :all
    can :read, :all

    if user.is_active == true
      can :manage, :all

      cannot :manage, Project unless user.is_admin == true
      can [:update, :destroy], Project do |project|
        user.in?(project.members) && project.memberships.where(user_id: user.id).first.role.in?(['Owner', 'Admin'])
      end
      can [:read, :create], Project

      cannot :manage, Oread::Application unless user.is_admin == true
      can [:update, :destroy], Oread::Application do |app|
        app.owner == user
      end
      can [:read, :create], Oread::Application
  
      cannot :manage, Doorkeeper::Application unless user.is_admin == true
      can [:update, :destroy, :create_accessibility, :update_accessibility, :destroy_accessibility], Doorkeeper::Application do |app|
        app.in?(user.all_oauth_applications) && user.all_oauth_accessibilities.where(oauth_application: app).map{|a| a.can_manage }.include?(true)
      end
      can [:read, :create], Doorkeeper::Application

      cannot :manage, OauthAccessibility unless user.is_admin == true
      can [:update, :destroy], OauthAccessibility do |acc|
        acc.in?(user.all_oauth_accessibilities) && user.all_oauth_accessibilities.where(oauth_application: acc.oauth_application).map{|a| a.can_manage }.include?(true)
      end
      can [:read], OauthAccessibility
      
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