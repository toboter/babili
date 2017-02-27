class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
     
    if user.is_admin == true
      can :manage, :all
    elsif user.is_active == true && user.is_admin == false
      can :manage, :all
      cannot :manage, User
      cannot [:new, :edit, :create, :update, :destroy], Oread::Application
      cannot [:new, :edit, :create, :update, :destroy], OreadAccessibility
      # cannot :manage, Project, user != Project.memberships.where(role: 'Owner').first.user
      can :manage, User, id: user.id
      # hier passiert noch ein tiefgreifender Konflikt zwischen Devise update und user update.
      can :read, User
      cannot :read, Doorkeeper::Application
    else
      can :read, :all
      can :read, Oread::Application
      cannot :read, User
      cannot :read, Doorkeeper::Application
    end
  end
end