module Api::V1
  class PeopleController < Api::V1::BaseController
    load_and_authorize_resource
    
    def index
      @people = @people.order(id: :asc)
      render template: "api/v1/people/index"
    end

    def show
      render template: "api/v1/people/show"
    end

    def organizations
      @organizations = @person.organizations.where(private: false).order(id: :asc)
      render template: "api/v1/people/organizations"
    end

    def memberships
      @memberships = @person.memberships
      render template: "api/v1/people/memberships"
    end

    def repositories
      @repositories = @person.user.oread_enrolled_applications.order(id: :asc)
      render template: "api/v1/people/repositories"
    end

  end
end
