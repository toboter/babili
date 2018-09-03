class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    cannot :manage, :all
    can :read, Person
    can :read, Organization, private: false
    can :read, Namespace
    can :read, [Vocab::Scheme, Vocab::Concept]
    can :read, Repository
    can :read, Biblio::Entry
    can :read, [Discussion::Comment, Discussion::Thread, Discussion::Assignment]
    can :read, Oread::Application
    can :read, Doorkeeper::Application
    can :read, [Zensus::Agent, Zensus::Appellation, Zensus::Event, Zensus::Activity]
    can :read, [CMS::BlogPage, CMS::Novelity, CMS::HelpPage]
    can :read, [Locate::Place, Locate::Dating, Locate::Toponym, Locate::Location]
    can :read, [Aggregation::Identifier, Aggregation::Item, Aggregation::Event, Aggregation::Commit]
    can :read, Writer::Document
    cannot :read, Writer::Document, published_at: nil
    cannot :read, CMS::BlogPage, published_at: nil
    cannot :read, Raw::FileUpload
    cannot :index, User

    if user
      can [:show, :create, :update], User do |u|
        u == user
      end
      can [:show, :edit, :update], Person do |person|
        person.user == user
      end
  
      if user.approved?
        #can :manage, :all
        if user.is_admin?
          can :manage, User
          can :manage, Oread::Application
          can :manage, Doorkeeper::Application
          can :manage, OauthAccessibility
          can :manage, Raw::FileUpload
          can :destroy, Biblio::Entry
          can :manage, [Zensus::Agent, Zensus::Appellation, Zensus::Event, Zensus::Activity]
          can :manage, [CMS::BlogPage, CMS::Novelity, CMS::HelpPage, CMS::HelpCategory, CMS::BlogCategory]
          can :manage, [Locate::Place, Locate::Dating, Locate::Toponym, Locate::Location]
          can :manage, [Aggregation::Identifier, Aggregation::Item, Aggregation::Event, Aggregation::Commit]
        end

        # Person
        ### todo
        ###  anpassen auf namespace permissions

        # Organization
        ###  anpassen auf namespace permissions
        can [:new, :create], Organization
        can :read, Organization do |organization|
          !organization.private? || user.person.in?(organization.members)
        end
        can [:update, :destroy], Organization do |organization| 
          user.person.in?(organization.members) && organization.memberships.where(person_id: user.person.id).first.role_admin?
        end      

        # Namespace
        can :manage, Namespace do |namespace|
          namespace.permissions.select { |p| p.person == user.person }.try(:first).try(:can_manage)
        end

        # Namespace/Vocab
        can [:new, :create], Vocab::Scheme do |scheme|
          scheme.namespace.permissions.select { |p| p.person == user.person }.try(:first).try(:can_create)
        end
        can [:edit, :update], Vocab::Scheme do |scheme|
          scheme.namespace.permissions.select { |p| p.person == user.person }.try(:first).try(:can_update)
        end
        can :destroy, Vocab::Scheme do |scheme|
          scheme.namespace.permissions.select { |p| p.person == user.person }.try(:first).try(:can_destroy)
        end
        can [:new, :create], Vocab::Concept do |concept|
          concept.scheme.namespace.permissions.select { |p| p.person == user.person }.try(:first).try(:can_create)
        end
        can [:edit, :update], Vocab::Concept do |concept|
          concept.scheme.namespace.permissions.select { |p| p.person == user.person }.try(:first).try(:can_update)
        end
        can :destroy, Vocab::Concept do |concept|
          concept.scheme.namespace.permissions.select { |p| p.person == user.person }.try(:can_destroy)
        end

        # Namespace/Repository
        can [:new, :create], Repository do |repo|
          repo.owner.permissions.select { |p| p.person == user.person }.try(:first).try(:can_create)
        end
        can [:edit, :update], Repository do |repo|
          repo.permissions.select { |p| p.person == user.person }.try(:first).try(:can_update)
        end
        can :destroy, Repository do |repo|
          repo.owner.permissions.select { |p| p.person == user.person }.try(:can_destroy)
        end

        # Namespace/Repository/Biblio::Referencation
        can [:add_reference, :destroy], Biblio::Referencation do |referencation|
          referencation.repository.permissions.select { |p| p.person == user.person }.try(:first).try(:can_update)
        end
        can :add_repository, Biblio::Referencation do |referencation|
          # referencation is nil
          user.person.all_repos.map{|r| r.permissions.select { |p| p.person == user.person }.try(:first).try(:can_update) }.compact.flatten.include?(true)
        end
        can [:new, :create], Biblio::Entry do |entry|
          entry.repositories.map{|r| r.permissions.select { |p| p.person == user.person }.try(:first).try(:can_create) }.compact.flatten.include?(true)
        end
        can [:edit, :update], Biblio::Entry do |entry|
          entry.repositories.map{|r| r.permissions.select { |p| p.person == user.person }.try(:first).try(:can_update) }.compact.flatten.include?(true)
        end

        # Namespace/Repository/Discussion
        can :manage, Discussion::Comment do |comment|
          user.person == comment.author && !comment.thread.locked?
        end
        can [:new, :create], Discussion::Comment do |comment|
          !comment.thread.locked?
        end
        can [:edit, :update, :close, :toggle_lock, :destroy, :assign], Discussion::Thread do |thread|
          user.person.in?(thread.moderators)
        end
        can [:new, :create], Discussion::Thread
        can [:new, :create, :destroy], Discussion::Assignment do |assignment|
          user.person.in?(assignment.thread.moderators)
        end

        # Namespace/Repository/Data
        ### todo
        ### anpassen auf repo.permissions
        can :manage, Aggregation::Identifier do |identifier|
          false
        end
        can :manage, Aggregation::Item do |item|
          false
        end
        can :manage, Aggregation::Event do |event|
          false
        end
        can :manage, Aggregation::Commit do |commit|
          false
        end

        # Namespace/Repository/Document
        ### todo
        can :manage, Writer::Document do |doc|
          doc.repository.permissions.select { |p| p.person == user.person }.try(:first).try(:can_manage)
        end


        # ----------------------------------------------------

        # Raw::Fileupload
        can :show, Raw::FileUpload
        can :create, Raw::FileUpload

        # Zensus
        ### todo
        can [:new, :create, :edit, :update], [Zensus::Agent, Zensus::Appellation, Zensus::Event, Zensus::Activity]

        # Locate
        ### todo
        can [:new, :create, :edit, :update], [Locate::Place, Locate::Dating, Locate::Toponym, Locate::Location]
  
        # Blog
        can [:new, :create], CMS::BlogPage
        can :read, CMS::BlogPage do |page|
          page.published? || page.author == user.person
        end
        can [:update, :destroy], CMS::BlogPage do |page|
          user.person == page.author
        end

        # Oread Apps
        can [:update, :destroy], Oread::Application do |app|
          app.owner == user
        end
        can [:read], Oread::Application
        # can create oread_access_token?
    
        # Oauth Apps
        can [:new, :create], Doorkeeper::Application
        can [:edit, :update, :destroy, :create_accessibility, :update_accessibility, :destroy_accessibility], Doorkeeper::Application do |app|
          app.in?(user.person.oauth_applications) && user.person.oauth_accessibilities.where(oauth_application: app).map{|a| a.can_manage }.include?(true)
        end
        can :read, OauthAccessibility
        can [:update, :destroy], OauthAccessibility do |acc|
          acc.in?(user.person.oauth_accessibilities) && user.person.oauth_accessibilities.where(oauth_application: acc.oauth_application).map{|a| a.can_manage }.include?(true)
        end

        can :manage, PersonalAccessToken do |token|
          token.resource_owner == user
        end
        can [:new, :create], PersonalAccessToken
        
      end
    end

  end
end