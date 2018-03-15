class Api::PeopleController < Api::BaseController
  load_and_authorize_resource
  
  def index
    people = @people.order(id: :asc)
    render json: people
  end

  def show
    render json: @person
  end

  def organizations
    organizations = @person.organizations.order(id: :asc)
    render json: organizations
  end

  def repositories
    repositories = @person.user.oread_enrolled_applications.order(id: :asc)
    render json: repositories, each_serializer: CollectionSerializer
  end




end