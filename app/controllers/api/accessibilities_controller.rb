class Api::AccessibilitiesController < Api::BaseController
  load_and_authorize_resource :user, only: %i[crud_abilities search_abilities]

  def crud_abilities
    oauth_accessibilities = current_resource_owner.all_combined_oauth_accessibility_grants
    render json: oauth_accessibilities, each_serializer: OauthApplicationSerializer
  end

  def search_abilities
    oread_applications = current_resource_owner.oread_applications
    render json: oread_applications, each_serializer: OreadApplicationSerializer
  end

end