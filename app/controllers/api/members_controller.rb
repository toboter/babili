class Api::MembersController < Api::BaseController
  load_and_authorize_resource :organization
  load_and_authorize_resource through: :organization, class: 'User', find_by: :username

  def index
    members = @members.joins(:memberships).where(memberships: {verified: true}).uniq.order(id: :asc)
    render json: members
  end

  def show
    if @member.present?
      render json: {status: 204}.to_json
    end
  end


end