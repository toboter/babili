class Api::ApplicationsController < Api::BaseController
  load_and_authorize_resource class: 'Doorkeeper::Application', find_by: :uid

  def index
    applications = @applications.order(id: :asc)
    render json: applications
  end

  def show
    render json: @application
  end
end