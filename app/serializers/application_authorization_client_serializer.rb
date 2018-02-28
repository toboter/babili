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
  has_many :person_accessors, each_serializer: PersonSerializer

  private
  def permissions
    object.grants(current_user.person)
  end
end