class MembershipsController < ApplicationController
  before_action :set_project
  before_action :set_membership, only: [:edit, :update, :destroy]
  before_action :authenticate_user!

  def new
    @users = User.all-@project.members
    @roles = @project.has_owner? ? ['Admin', 'Member'] : ['Owner', 'Admin', 'Member']
    @membership = @project.memberships.new
  end
  
  def edit
    @users = Array(@membership.user)
    @roles = @membership.project.has_owner? ? (@membership.is_owner? ? ['Owner'] : ['Admin', 'Member']) : ['Owner', 'Admin', 'Member']
  end
  
  def create
    @membership = @project.memberships.new(membership_params)

    respond_to do |format|
      if @membership.save
        format.html { redirect_to @project, notice: 'Membership was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @membership.update(membership_params)
        format.html { redirect_to @project, notice: 'Membership was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @membership.destroy unless @membership.is_owner?
    respond_to do |format|
      format.html { redirect_to @project, notice: 'Membership was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.friendly.find(params[:project_id])
    end
    
    def set_membership
      @membership = @project.memberships.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def membership_params
      params.require(:membership).permit(:user_id, :role, :project_id)
    end
    
end
