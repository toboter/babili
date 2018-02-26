class Api::MembershipsController < Api::BaseController
  load_and_authorize_resource :organization
  load_and_authorize_resource :member, parent: false, through: :organization, class: 'User', find_by: :username

  def show
    # @membership = @organization.memberships.joins(:user).where(users: {username: params[:id]}).first
    @membership = @organization.memberships.find_by_user_id(@member)
    render json: @membership
  end


end