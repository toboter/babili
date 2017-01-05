class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
     
    if user.is_admin == true
      can :manage, :all     
    elsif user.is_active == true && user.is_admin == false
      can :manage, :all
      cannot :manage, User
      # cannot :manage, Project, user != Project.memberships.where(role: 'Owner').first.user
      can :manage, User, id: user.id
      # hier passiert noch ein tiefgreifender Konflikt zwischen Devise update und user update.
    else
      can :read, :all
      can :read, Search::Application
      cannot :read, User    
    end
  end
end