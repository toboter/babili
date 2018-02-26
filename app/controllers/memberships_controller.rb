class MembershipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organization

  def create #apply
    @applyment = current_user.memberships.new(organization: @organization, verified: false, role: 'Member')

    respond_to do |format|
      if @applyment.save
        format.html { redirect_to settings_organizations_path, notice: "Successfully applied for #{@organization.name}." }
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
    @membership = @organization.memberships.find(params[:id])
    @membership.destroy unless @membership.role == 'Admin'
    respond_to do |format|
      format.html { redirect_to settings_organizations_path, notice: "Organization #{@membership.verified? ? 'membership' : 'application' } was successfully removed." }
    end
  end

  private
  def set_organization
    @organization = Organization.friendly.find(params[:settings_organization_id])
  end

  def membership_params
    params.require(:membership).permit(:_delete, :user_id, :organization_id)
  end


end