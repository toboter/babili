class OauthAccessibilitiesController < ApplicationController
  before_action :set_oauth_application
  before_action :set_oauth_accessibility, only: [:edit, :update, :destroy]
  before_action :authenticate_user!
  load_and_authorize_resource :oauth_application
  load_and_authorize_resource :accessibility, class: 'OauthAccessibility', :through => :oauth_application
  require 'uri'
  require 'rest-client'
  require 'json'

  def new
    @accessors = Project.where.not(id: @oauth_application.project_accessor_ids) + User.where.not(id: @oauth_application.user_accessor_ids)
    @oauth_accessibility = @oauth_application.accessibilities.new
  end

  def edit
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

  def update
    respond_to do |format|
      if @oauth_accessibility.update(oauth_accessibility_params)
        format.html { redirect_to oauth_application_path(@oauth_application), flash: { success: 'Accessibility was successfully updated.' } }
        format.json { render :show, status: :ok, location: @oauth_application }
      else
        format.html { render :edit }
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
      params.require(:oauth_accessibility).permit(:accessor, :application_id, :creator_id, 
        :can_manage, :can_create, :can_read, :can_update, :can_destroy, :can_comment, :can_publish)
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