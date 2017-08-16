class OauthAccessibilitiesController < ApplicationController
  before_action :set_oauth_application
  before_action :set_oauth_accessibility, only: [:edit, :update, :destroy]
  before_action :authenticate_user!
  require 'uri'
  require 'rest-client'
  require 'json'

  def new
    @projects = Project.where.not(id: @oauth_application.project_ids)
    @oauth_accessibility = @oauth_application.accessibilities.new
  end
  
  def create
    @oauth_accessibility = @oauth_application.accessibilities.new(oauth_accessibility_params)
    @oauth_accessibility.creator_id = current_user.id
    
    respond_to do |format|
      if @oauth_accessibility.save
        format.html { redirect_to oauth_application_path(@oauth_application), notice: 'Accessibility was successfully created.' }
        format.json { render :show, status: :created, location: @oauth_application }
      else
        format.html { render :new }
        format.json { render json: @oauth_application.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @oauth_accessibility.destroy
    respond_to do |format|
      format.html { redirect_to oauth_application_path(@oauth_application), notice: 'Accessibility was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_oauth_application
      @oauth_application = Doorkeeper::Application.find(params[:oauth_application_id])
    end
    
    def set_oauth_accessibility
      @oauth_accessibility = @oauth_application.accessibilities.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def oauth_accessibility_params
      params.require(:oauth_accessibility).permit(:project_id, :application_id, :creator_id)
    end

    # def project_hook(oauth_accessibility)
    #   uri = URI(oauth_accessibility.oauth_application.redirect_uri)
    #   api_url = uri.scheme + "://" + uri.host + ":" + uri.port.to_s + "/api/projects/update_access"
    #   RestClient.post(api_url, {
    #     project_id: oauth_accessibility.project.id, 
    #     project_name: oauth_accessibility.project.name,
    #     project_member_ids: oauth_accessibility.project.member_ids
    #   }.to_json, content_type: 'application/json', accept: :json)
    # end
    
end