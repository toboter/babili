class OrganizationSerializer < ActiveModel::Serializer
  attributes :id, :name, :member_ids, :oauth_application_uids

  def member_ids
    object.members.order(id: :asc).map{|m| m.user.id} if object.members.any?
  end

  def oauth_application_uids
    object.accessible_oauth_apps.map(&:uid) if object.accessible_oauth_apps.any?
  end

end
