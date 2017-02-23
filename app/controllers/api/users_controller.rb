class Api::UsersController < Api::BaseController
  load_and_authorize_resource only: %i[index me show]

  def index
    users = User.accessible_by(current_ability).all
    render json: users
  end

  def me
    render json: current_resource_owner
  end
  
  def show
    user = User.accessible_by(current_ability).find(params[:id])
    render json: user
  end

end