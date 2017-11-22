class Api::MembershipsController < Api::BaseController
  load_and_authorize_resource :project
  load_and_authorize_resource :member, parent: false, through: :project, class: 'User', find_by: :username

  def show
    # @membership = @project.memberships.joins(:user).where(users: {username: params[:id]}).first
    @membership = @project.memberships.find_by_user_id(@member)
    render json: @membership
  end


end