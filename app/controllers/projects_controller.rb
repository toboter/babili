class ProjectsController < ApplicationController
  require 'rest-client'
  
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  after_action :send_update_ping_to_clients, only: [:create, :update]
  load_and_authorize_resource
  
  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.all
    @personal_projects = @projects.joins(:memberships).where('memberships.user_id = ?', current_user.id)
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
    @project.memberships.build(user: current_user, role: 'Owner')

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
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
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
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
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
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
      params.require(:project).permit(:name, :image_data, :description, :data_published)
    end
    
    def send_update_ping_to_clients
      @project.applications.each do |app|
        if app.oauth_application
          app_url = app.host
          app_token = app.oauth_application.access_tokens.where(resource_owner_id: current_user.id).first.token
          RestClient.post("#{app_url}/api/projects", {}, {'Authorization' => "Token #{app_token}"})
        end
      end if @project.applications.any?
    end
end
