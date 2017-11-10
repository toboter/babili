class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    cannot :manage, :all
    can :read, :all

    if user.approved?
      can :manage, :all

      cannot :manage, [Novelity, About] unless user.is_admin?
      can :read, [Novelity, About]
      cannot :manage, Post unless user.is_admin?
      can [:read, :create], Post
      can [:update, :destroy], Post do |post|
        user == post.author
      end

      cannot :manage, Project unless user.is_admin?
      can [:update, :destroy], Project do |project|
        user.in?(project.members) && project.memberships.where(user_id: user.id).first.role.in?(['Owner', 'Admin'])
      end
      can [:create], Project
      can [:read], Project do |project|
        !project.private? || user.in?(project.members)
      end

      cannot :manage, Oread::Application unless user.is_admin?
      can [:update, :destroy], Oread::Application do |app|
        app.owner == user
      end
      can [:read], Oread::Application

      # can create oread_access_token?
  
      cannot :manage, Doorkeeper::Application unless user.is_admin?
      can [:index, :update, :destroy, :create_accessibility, :update_accessibility, :destroy_accessibility], Doorkeeper::Application do |app|
        app.in?(user.all_oauth_applications) && user.all_oauth_accessibilities.where(oauth_application: app).map{|a| a.can_manage }.include?(true)
      end
      can [:show, :create], Doorkeeper::Application

      cannot :manage, OauthAccessibility unless user.is_admin?
      can [:update, :destroy], OauthAccessibility do |acc|
        acc.in?(user.all_oauth_accessibilities) && user.all_oauth_accessibilities.where(oauth_application: acc.oauth_application).map{|a| a.can_manage }.include?(true)
      end
      can [:read], OauthAccessibility
      
    end

    can :manage, User if user.is_admin?
    cannot :index, User unless user.is_admin?
    can [:show, :create, :update, :destroy], User do |u|
      u == user
    end
    can [:create, :update, :edit, :new], Profile do |p|
      p.user == user
    end

  end
end