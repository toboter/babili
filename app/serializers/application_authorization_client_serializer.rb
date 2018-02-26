class ApplicationAuthorizationClientSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :url, :scopes, :token, :user_permissions, :app, :updated_at, :created_at

  def url
    api_authorization_url(object)
  end

  def token
    object.access_tokens.where(resource_owner_id: current_user).last.try(:token)
  end
  
  attribute :app do
    {
      url: api_application_url(object.uid),
      name: object.name,
      client_id: object.uid
    }
  end

  attribute :user_permissions do
    {
      create: permissions.can_create,
      read: permissions.can_read,
      update: permissions.can_update,
      destroy: permissions.can_destroy,
      extra: {
        manage: permissions.can_manage,
        comment: permissions.can_comment,
        publish: permissions.can_publish
      }
    }
  end

  has_many :organization_accessors, each_serializer: OrganizationSerializer
  has_many :user_accessors, each_serializer: UserSerializer

  private
  def permissions
    obj = object.accessibilities.new
    object.accessibilities.where(id: current_user.all_oauth_accessibilities.ids).each do |a|
      obj.can_manage = true if a.can_manage?
      obj.can_create = true if a.can_create? || a.can_manage?
      obj.can_read = true if a.can_read? || a.can_manage?
      obj.can_update = true if a.can_update? || a.can_manage?
      obj.can_destroy = true if a.can_destroy? || a.can_manage?
      obj.can_comment = true if a.can_comment? || a.can_manage?
      obj.can_publish = true if a.can_publish? || a.can_manage?
    end
    # oauth_accessibilities = current_user.all_combined_oauth_accessibility_grants
    obj
  end
end