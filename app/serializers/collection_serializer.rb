class CollectionSerializer < ActiveModel::Serializer
  include ActiveModel::Serializers
  include Rails.application.routes.url_helpers

  attributes :id, :name, :uid, :host, :port, :url, :user_access_token, :provider_presentation_human
  has_many :collection_classes

  def user_access_token
    object.access_tokens.where(resource_owner: current_user).last.try(:token)
  end

  def provider_presentation_human
    url_for([object, {only_path: Rails.env.test?}])
  end
  
  belongs_to :owner, serializer: UserSerializer

end