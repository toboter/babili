module Api::V1
  class ApplicationAuthorizationSerializer < ActiveModel::Serializer
    include Rails.application.routes.url_helpers

    attributes :id, :url, :scopes, :token, :user_permissions, :app, :updated_at, :created_at

    def url
      v1_authorization_url(object)
    end

    def token
      object.access_tokens.where(resource_owner_id: current_user).last.try(:token)
    end
    
    attribute :app do
      {
        url: v1_application_url(object.uid),
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

    private
    def permissions
      object.grants(current_user.person)
    end
  end
end