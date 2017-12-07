class Api::BaseController < ActionController::API
  # testing token:  nH3ydH1KRRDA6AWDs6yhtw5u
  # doorkeeper literature token:  6039d4aa3df371e4d586ec1df6068776a3051199690c98898af3b244c356aa61

  include CanCan::ControllerAdditions

  clear_respond_to
  respond_to :json

  # before_action :authorization_method

  # before_action -> { doorkeeper_authorize! :public } # if: _auth_method == doorkeeper
  # before_action only: [:create, :update, :destroy] do
  #   doorkeeper_authorize! :admin, :write, :update
  # end

  before_action :doorkeeper_authorize!
  before_action :authenticate_user_with_doorkeeper!
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
    def authenticate_user_with_doorkeeper!
      if doorkeeper_token
        @current_user = User.find(doorkeeper_token.resource_owner_id)
      end

      return if current_user

      render json: { errors: ['User is not authenticated! (Doorkeeper::Auth)'] }, status: :unauthorized
    end

    def authenticate_user_with_personal_token!
      if request.headers['Authorization'] || params[:access_token]
        token = request.headers['Authorization'] ? request.headers['Authorization'].split(' ').last : params[:access_token]
        @personal_access_token = PersonalAccessToken.find_by_access_token(token)
        @current_user = @personal_access_token.resource_owner if @personal_access_token
      end 
  
      return if current_user
  
      render json: { errors: ['User is not authenticated! (PersonalAccessToken::Auth)'] }, status: :unauthorized
    end

    def authorize_personal_api_methods(method)
      # raise @personal_access_token.send(method).inspect #
      return if @personal_access_token && @personal_access_token.send(method) == true

      render json: { errors: ["User is authenticated. Scope: '#{method}' is not set for this authorization request."] }, status: :unauthorized
    end

    def current_user
      @current_user.presence || false
    end
    helper_method :current_user

    def errors_json(messages)
      { errors: [*messages] }
    end
end


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