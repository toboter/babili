class Audit < ApplicationRecord
# Monitor security relevant actions in your users environment.
# Add th following to specific actions:
# Audit.create!(user: @application.owner, actor: current_user, action: "oauth_application.create", action_description: @application.name, actor_ip: current_user.last_sign_in_ip)
# user: the owner of a resource
# actor: the user who manipulates the resource
# action: what happend

  belongs_to :user
  belongs_to :actor, class_name: 'User'
end
