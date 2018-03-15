class OreadApplicationSerializer < ActiveModel::Serializer
  include ActiveModel::Serializers
  include Rails.application.routes.url_helpers

  attributes :id, :name, :host, :port, :url, :user_access_token, :provider_presentation_human
  has_many :collection_classes

  def user_access_token
    object.access_tokens.where(resource_owner: current_user).last.try(:token)
  end

  def provider_presentation_human
    url_for([object, {only_path: Rails.env.test?}])
  end
  
  attribute :owner do
    {
      name: object.owner.try(:name),
      human: url_for([object.owner, {only_path: Rails.env.test?}])
    }
  end

end