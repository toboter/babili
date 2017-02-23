class OauthApplicationSerializer < ActiveModel::Serializer
  include ActiveModel::Serializers

  attributes :uid, :name, :owner, :scope

  def owner
    object.owner.try(:id)
  end

  def scope
    'all'
  end
end