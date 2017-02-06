class Api::ProjectsController < ActionController::API
  # load_and_authorize_resource only: %i[index]
  # load_and_authorize_resource param_method: :update_params, on: :update
  # load_and_authorize_resource param_method: :create_params, on: :create

  def index
    doorkeeper_token = Doorkeeper::AccessToken.find_by_token(request.headers['Authorization'].split(' ').last) if request.headers['Authorization']
    
    if doorkeeper_token
      Thread.current[:current_user] = User.find(doorkeeper_token.resource_owner_id)
    end

    if doorkeeper_token && current_user
      # current_user = User.find(doorkeeper_token.resource_owner_id)
      public_projects = Project.where(data_published: true) || []
      user_projects = current_user.projects || []
      projects = (user_projects + public_projects).uniq #Project.accessible_by(current_ability).all
    else
      projects = Project.where(data_published: true)
    end
    
    render json: projects
  end

private
  def current_user
    Thread.current[:current_user]
  end

end