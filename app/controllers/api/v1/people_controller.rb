module Api::V1
  class PeopleController < Api::V1::BaseController
    load_and_authorize_resource
    
    def index
      people = @people.order(id: :asc)
      render json: people, each_serializer: PersonSerializer
    end

    def show
      render json: @person, serializer: PersonSerializer
    end

    def organizations
      organizations = @person.organizations.where(private: false).order(id: :asc)
      render json: organizations, each_serializer: OrganizationSerializer, adapter: :json
    end

    def memberships
      memberships = @person.memberships
      render json: memberships, each_serializer: MembershipSerializer
    end

    def repositories
      repositories = @person.user.oread_enrolled_applications.order(id: :asc)
      render json: repositories, each_serializer: CollectionSerializer
    end

  end
end