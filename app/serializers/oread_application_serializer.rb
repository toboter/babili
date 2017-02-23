class OreadApplicationSerializer < ActiveModel::Serializer
  include ActiveModel::Serializers

  attributes :id, :name, :owner, :user_access_token, :url, :scope

  def owner
    object.owner.try(:id)
  end

  def user_access_token
    object.access_tokens.where(resource_owner: Thread.current[:current_user]).last.try(:token)
  end

  def scope
    'all'
  end
end