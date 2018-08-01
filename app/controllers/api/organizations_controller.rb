class Api::OrganizationsController < Api::BaseController
  load_and_authorize_resource

  def index
    organizations = @organizations.where(private: false).order(id: :asc)
    render json: organizations
  end

  def show
    render json: @organization.private? ? {status: 'Not Found', code: 404}.to_json : @organization
  end

end