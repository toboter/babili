class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    cannot :manage, :all
    can :read, :all
    cannot :read, [CMS::HelpCategory, CMS::BlogCategory, CMS::BlogPage]
    can :read, CMS::BlogPage do |page|
      page.published_at.present?
    end

    if user.approved?
      can :manage, :all

      cannot :manage, [CMS::Novelity, CMS::HelpPage, CMS::HelpCategory, CMS::BlogCategory] unless user.is_admin?
      cannot :read, [CMS::HelpCategory, CMS::BlogCategory] unless user.is_admin?
      can :read, [CMS::Novelity, CMS::HelpPage]
      cannot :manage, CMS::BlogPage unless user.is_admin?
      can :create, CMS::BlogPage
      can :read, CMS::BlogPage do |page|
        page.published_at.present? || page.author == user
      end
      can [:update, :destroy], CMS::BlogPage do |post|
        user == post.author
      end

      cannot :manage, Project unless user.is_admin?
      # in folgendes noch Memberships aufnehmen?
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
      can [:update, :destroy, :create_accessibility, :update_accessibility, :destroy_accessibility], Doorkeeper::Application do |app|
        app.in?(user.all_oauth_applications) && user.all_oauth_accessibilities.where(oauth_application: app).map{|a| a.can_manage }.include?(true)
      end
      can [:read, :create], Doorkeeper::Application

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

    cannot :manage, [Zensus::Agent, Zensus::Event, Zensus::Activity] unless user
  end
end