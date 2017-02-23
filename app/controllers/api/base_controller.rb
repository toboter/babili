class Api::BaseController < ActionController::API
  include CanCan::ControllerAdditions

  clear_respond_to
  respond_to :json

  # über auth checks
  # http://www.polyglotprogramminginc.com/a-sane-oauth-federation-strategy-with-doorkeeper-in-ruby/
  # provider example
  # https://github.com/rilian/devise-doorkeeper-cancan-api-example/
  # client example
  # https://github.com/doorkeeper-gem/doorkeeper-devise-client/
  # doorkeeper github page
  # https://github.com/doorkeeper-gem/doorkeeper
  # doorkeeper railscast
  # http://railscasts.com/episodes/353-oauth-with-doorkeeper?view=asciicast
  
  before_action :doorkeeper_authorize!
  before_action :authenticate_user!

  check_authorization unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |e|
    render json: errors_json(e.message), status: :forbidden
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: errors_json(e.message), status: :not_found
  end
  def doorkeeper_unauthorized_render_options(error: nil)
    { json: { error: "Not authorized" }, status: :unauthorized }
  end
  
private
  # Find the user that owns the access token
  def current_resource_owner
    @current_resource_owner = User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
  helper_method :current_resource_owner
  
  def authenticate_user!
    if doorkeeper_token
      Thread.current[:current_user] = User.find(doorkeeper_token.resource_owner_id)
    end

    return if current_user

    render json: { errors: ['User is not authenticated!'] }, status: :unauthorized
  end

  def current_user
    Thread.current[:current_user]
  end

  def errors_json(messages)
    { errors: [*messages] }
  end
end