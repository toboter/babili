module Doorkeeper
  class ApplicationsController < ActionController::Base
    before_action :authenticate_user!, except: [:index, :show]
    load_and_authorize_resource :application, class: 'Doorkeeper::Application'
    
    def index
      @applications = Application.order(name: :asc).all
    end

    def show; end

    def new
      @application = Application.new
    end
    
    def create
      @application = Application.new(application_params)
      if @application.save
        flash[:notice] = I18n.t(:notice, scope: [:doorkeeper, :flash, :applications, :create])
        redirect_to oauth_application_url(@application)
      else
        render :new
      end
    end

    def edit; end

    def update
      if @application.update_attributes(application_params)
        flash[:notice] = I18n.t(:notice, scope: [:doorkeeper, :flash, :applications, :update])
        redirect_to oauth_application_url(@application)
      else
        render :edit
      end
    end

    def destroy
      flash[:notice] = I18n.t(:notice, scope: [:doorkeeper, :flash, :applications, :destroy]) if @application.destroy
      redirect_to oauth_applications_url
    end

    private

    def application_params
      params.require(:doorkeeper_application).permit(:name, :redirect_uri, :scopes)
    end
    
  end
end