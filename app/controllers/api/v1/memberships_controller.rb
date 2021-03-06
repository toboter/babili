module Api::V1
  class MembershipsController < Api::V1::BaseController
    load_and_authorize_resource :organization
    load_and_authorize_resource :member, parent: false, through: :organization, class: 'Person'

    def show
      # @membership = @organization.memberships.joins(:user).where(users: {username: params[:id]}).first
      @membership = @organization.memberships.find_by_person_id(@member.id)
      render json: @membership, serializer: MembershipSerializer
    end


  end
end