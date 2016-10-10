class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.is_admin?
      can :manage, :all
    else
      can :manage, User, id: user.id
      cannot :read, User
    end
  end
end