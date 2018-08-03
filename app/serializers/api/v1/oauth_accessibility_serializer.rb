module Api::V1
  class OauthAccessibilitySerializer < ActiveModel::Serializer
    include ActiveModel::Serializers

    attributes :id, :oauth_application, :can_manage, :can_create, :can_read, :can_update, :can_destroy, :can_comment, :can_publish

    def id
      object.oauth_application_id
    end

    # memberships <- read?

  end
end