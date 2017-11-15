class Api::OreadCollectionsController < Api::BaseController
  require 'rest-client'
  require 'json'
  include ERB::Util

  skip_before_action :doorkeeper_authorize!
  skip_before_action :authenticate_user_with_doorkeeper!
  skip_authorization_check

  before_action :authenticate_user_with_personal_token!
  before_action  -> { authorize_personal_api_methods(:collections) }, only: :index
  
  def index
  end

end