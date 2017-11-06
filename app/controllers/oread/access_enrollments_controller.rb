class Oread::AccessEnrollmentsController < ApplicationController
  before_action :authenticate_user!
  layout "settings"

  def index
    @applications = Oread::Application.order(name: :asc) #current_user.oread_applications.order(name: :asc).uniq #oread_access_tokens
    # current_user.oread_enrolled_applications
    # current_user.oread_token_applications
  end

end