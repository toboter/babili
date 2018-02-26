class OrganizationSerializer < ActiveModel::Serializer
  attributes :id, :name, :member_ids, :oauth_application_uids

  def member_ids
    object.members.order(id: :asc).map(&:id) if object.members.any?
  end

  def oauth_application_uids
    object.oauth_applications.map(&:uid) if object.oauth_applications.any?
  end

end
