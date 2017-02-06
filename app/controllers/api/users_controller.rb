class Api::UsersController < Api::BaseController
  load_and_authorize_resource only: %i[index me show]
  # load_and_authorize_resource param_method: :update_params, on: :update
  # load_and_authorize_resource param_method: :create_params, on: :create

  def index
    users = User.accessible_by(current_ability).all
    render json: users
  end

  def me
    render json: current_user
  end
  
  def show
    render json: User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  # def update
  #   user = User.find(params[:id])
  #   if user.update(update_params)
  #     render json: user, serialzier: UserSerializer, status: 200
  #   else
  #     render json: { errors: user.errors }, status: 422
  #   end
  # end

private
  # Find the user that owns the access token
  # def current_resource_owner
  #   User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  # end
  
  # def update_params
  #   params.permit(:email, :password)
  # end
end