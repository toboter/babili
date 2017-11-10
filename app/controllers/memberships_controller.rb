class MembershipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project

  def create #apply
    @applyment = current_user.memberships.new(project: @project, verified: false, role: 'Member')

    respond_to do |format|
      if @applyment.save
        format.html { redirect_to settings_projects_path, notice: "Successfully applied for #{@project.name}." }
        format.json { render :show, status: :created, location: @applyment }
        format.js
      else
        format.html { render :new }
        format.json { render json: @applyment.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def destroy #leave
    @membership = @project.memberships.find(params[:id])
    @membership.destroy unless @membership.role == 'Owner'
    respond_to do |format|
      format.html { redirect_to settings_projects_path, notice: "Project #{@membership.verified? ? 'membership' : 'application' } was successfully removed." }
    end
  end

  private
  def set_project
    @project = Project.friendly.find(params[:settings_project_id])
  end

  def membership_params
    params.require(:membership).permit(:_delete, :user_id, :project_id)
  end


end