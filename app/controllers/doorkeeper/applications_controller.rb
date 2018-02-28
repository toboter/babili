module Doorkeeper
  class ApplicationsController < Doorkeeper::ApplicationController
    before_action :authenticate_user!
    # Added authorization
    load_and_authorize_resource :application, class: 'Doorkeeper::Application'

    def index
      @applications = current_user.applications.order(name: :asc)
    end

    def show
      # Changed layout
      render layout: 'application'
    end

    def new
      @application = Doorkeeper::Application.new
    end
    
    def create
      @application = Doorkeeper::Application.new(application_params)
      @application.owner = current_user if Doorkeeper.configuration.confirm_application_owner?
      if @application.save
        # Added audit
        Audit.create!(user: @application.owner, actor: current_user, action: "oauth_application.create", action_description: @application.name, actor_ip: current_user.last_sign_in_ip)
        flash[:notice] = I18n.t(:notice, scope: [:doorkeeper, :flash, :applications, :create])
        redirect_to oauth_applications_url
      else
        render :new
      end
    end

    def edit; end

    def update
      if @application.update_attributes(application_params)
        flash[:notice] = I18n.t(:notice, scope: [:doorkeeper, :flash, :applications, :update])
        redirect_to oauth_applications_url
      else
        render :edit
      end
    end

    def destroy
      # Added audit
      Audit.create!(user: @application.owner, actor: current_user, action: "oauth_application.destroy", action_description: @application.name, actor_ip: current_user.last_sign_in_ip)
      flash[:notice] = I18n.t(:notice, scope: [:doorkeeper, :flash, :applications, :destroy]) if @application.destroy
      redirect_to oauth_applications_url
    end

    private

    def application_params
      # Added :homepage_url and :description attributes
      params.require(:doorkeeper_application).permit(:name, :redirect_uri, :scopes, :homepage_url, :description)
    end
    
  end
end