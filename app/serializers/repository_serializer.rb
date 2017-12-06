class RepositorySerializer < ActiveModel::Serializer
  include ActiveModel::Serializers
  include Rails.application.routes.url_helpers

  attributes :id, :name, :uid, :host, :port, :path, :url, :user_access_token, :provider_presentation_human

  def user_access_token
    object.access_tokens.where(resource_owner: current_user).last.try(:token)
  end

  def path
    object.search_path
  end

  def provider_presentation_human
    url_for([object, {only_path: Rails.env.test?}])
  end
  
  belongs_to :owner, serializer: UserSerializer

end