class ProjectsController < ApplicationController
  require 'uri'
  require 'rest-client'
  require 'json'
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: :show
  load_and_authorize_resource
  layout "settings", except: :show

  # GET /projects
  # GET /projects.json
  def index
    @applyments = current_user.memberships.joins(:project).where(verified: false).order('projects.name ASC')
    @memberships = current_user.memberships.joins(:project).where(verified: true).order('projects.name ASC')
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
    @users = User.all
    @roles = ['Member', 'Admin', 'Owner']
    @project.memberships.build(user: current_user, role: 'Owner', verified: true)
  end

  # GET /projects/1/edit
  def edit
    @users = User.all
    @roles = ['Member', 'Admin', 'Owner']
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to settings_projects_path, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    old_ids = @project.member_ids.dup
    respond_to do |format|
      if @project.update(project_params)
        new_ids = Project.find(@project).member_ids
        changed_ids = (old_ids-new_ids) + (new_ids-old_ids)
        @project.oauth_applications.each do |app|
          UpdateClientAppUserAccessibilitiesJob.perform_later(app.id, changed_ids)
        end
        format.html { redirect_to settings_projects_path, notice: "Project was successfully updated." }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to settings_projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(
        :name, 
        :image, 
        :cached_image_data, 
        :private, 
        :description, 
        memberships_attributes: [:id, :user_id, :role, :verified, :_destroy])
    end
    
end
