class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    cannot :manage, :all
    can :read, :all
    cannot :read, [CMS::HelpCategory, CMS::BlogCategory]
    cannot :read, CMS::BlogPage do |page|
      !page.published?
    end
    cannot :read, Organization, private: true

    if user.approved?
      can :manage, :all

      cannot :manage, [CMS::Novelity, CMS::HelpPage, CMS::HelpCategory, CMS::BlogCategory] unless user.is_admin?
      cannot :read, [CMS::HelpCategory, CMS::BlogCategory] unless user.is_admin?
      can :read, [CMS::Novelity, CMS::HelpPage]
      cannot :manage, CMS::BlogPage unless user.is_admin?
      can :create, CMS::BlogPage
      can :read, CMS::BlogPage do |page|
        page.published_at.present? || page.author == user.person
      end
      can [:update, :destroy], CMS::BlogPage do |post|
        user.person == post.author
      end

      cannot :manage, Organization unless user.is_admin?
      # in folgendes noch Memberships aufnehmen?
      can [:update, :destroy], Organization do |organization| 
        user.person.in?(organization.members) && organization.memberships.where(person_id: user.person.id).first.role == 'Admin'
      end
      can [:create], Organization
      can :read, Organization, members: { id: user.person.id }

      cannot :manage, Oread::Application unless user.is_admin?
      can [:update, :destroy], Oread::Application do |app|
        app.owner == user
      end
      can [:read], Oread::Application

      # can create oread_access_token?
  
      cannot :manage, Doorkeeper::Application unless user.is_admin?
      can [:update, :destroy, :create_accessibility, :update_accessibility, :destroy_accessibility], Doorkeeper::Application do |app|
        app.in?(user.person.oauth_applications) && user.person.oauth_accessibilities.where(oauth_application: app).map{|a| a.can_manage }.include?(true)
      end
      can [:read, :create], Doorkeeper::Application

      cannot :manage, OauthAccessibility unless user.is_admin?
      can [:update, :destroy], OauthAccessibility do |acc|
        acc.in?(user.person.oauth_accessibilities) && user.person.oauth_accessibilities.where(oauth_application: acc.oauth_application).map{|a| a.can_manage }.include?(true)
      end
      can [:read], OauthAccessibility
      
    end

    can :manage, User if user.is_admin?
    cannot :index, User unless user.is_admin?
    can [:show, :create, :update, :destroy], User do |u|
      u == user
    end
    can [:update, :edit], Person do |p|
      p.user == user
    end

    cannot :manage, [Zensus::Agent, Zensus::Event, Zensus::Activity] unless user
  end
end