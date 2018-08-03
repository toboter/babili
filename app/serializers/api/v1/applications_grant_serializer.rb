module Api::V1
  class ApplicationsGrantSerializer < ActiveModel::Serializer
    include Rails.application.routes.url_helpers

    attributes :id, :url, :app, :created_at, :scopes

    def url
      v1_grant_url(object)
    end

    
    attribute :app do
      {
        url: v1_application_url(object.application.uid),
        name: object.application.name,
        client_id: object.application.uid
      }
    end

  end
end