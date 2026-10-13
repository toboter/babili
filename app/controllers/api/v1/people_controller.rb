module Api::V1
  class PeopleController < Api::V1::BaseController
    load_and_authorize_resource
    
    def index
      people = @people.order(id: :asc)
      render_with_serializer(people, each_serializer: PersonSerializer)
    end

    def show
      render_with_serializer(@person, serializer: PersonSerializer)
    end

    def organizations
      organizations = @person.organizations.where(private: false).order(id: :asc)
      render_with_serializer(organizations, each_serializer: OrganizationSerializer)
    end

    def memberships
      memberships = @person.memberships
      render_with_serializer(memberships, each_serializer: MembershipSerializer)
    end

    def repositories
      repositories = @person.user.oread_enrolled_applications.order(id: :asc)
      render_with_serializer(repositories, each_serializer: CollectionSerializer)
    end

  end
end