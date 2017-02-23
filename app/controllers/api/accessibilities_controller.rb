class Api::AccessibilitiesController < Api::BaseController
  load_and_authorize_resource :user, only: %i[write_authorization read_authorization]

  def write_authorization
    oauth_applications = Doorkeeper::Application.where(id: current_resource_owner.projects.map{|p| p.oauth_applications.ids }.flatten.uniq)
    render json: oauth_applications, each_serializer: OauthApplicationSerializer
  end

  def read_authorization
    oread_applications = Oread::Application.where(id: current_resource_owner.projects.map{|p| p.oread_applications.ids }.flatten.uniq)
    render json: oread_applications, each_serializer: OreadApplicationSerializer
  end

end