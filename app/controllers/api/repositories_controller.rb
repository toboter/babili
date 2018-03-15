class Api::RepositoriesController < Api::BaseController
  load_and_authorize_resource :namespace
  load_and_authorize_resource through: :namespace
  
  def index
    render json: @repositories
  end

  def show
    render json: @repository
  end



end