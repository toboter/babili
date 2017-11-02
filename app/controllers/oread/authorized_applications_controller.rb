module Oread
  class Oread::AuthorizedApplicationsController < ApplicationController
    before_action :authenticate_user!
    layout "settings"

    def index
      @authorized_applications = Oread::Application.order(name: :asc) #current_user.oread_applications.order(name: :asc).uniq #oread_access_tokens
    end

  end
end