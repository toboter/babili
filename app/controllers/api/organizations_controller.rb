class Api::OrganizationsController < Api::BaseController
  load_and_authorize_resource

  def index
    organizations = Organization.where(private: false).order(id: :asc)
    render json: organizations
  end

  def show
    # if private 403
    organization = Organization.where(private: false).find(params[:id])
    render json: organization
  end
end