module Api::V1
  class ApplicationSerializer < ActiveModel::Serializer
    include Rails.application.routes.url_helpers

    attribute :id
    belongs_to :owner, serializer: UserSerializer

    attributes :name, :description, :url, :html_url, :client_id, :created_at, :updated_at, :scopes

    def url
      v1_application_url(object.uid)
    end

    def html_url
      oauth_application_url(object)
    end

    def client_id
      object.uid
    end

  end
end