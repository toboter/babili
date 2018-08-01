class Api::MembersController < Api::BaseController
  load_and_authorize_resource :organization
  load_and_authorize_resource through: :organization, class: 'Person'

  def index
    members = @members.order(id: :asc).joins(:memberships).where(memberships: {verified: true}).uniq
    render json: members, each_serializer: PersonSerializer
  end

  def show
    if @member.present?
      render json: {status: 204}.to_json
    end
  end


end