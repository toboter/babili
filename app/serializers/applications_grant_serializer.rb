class ApplicationsGrantSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :url, :app, :created_at, :scopes

  def url
    api_grant_url(object)
  end

  
  attribute :app do
    {
      url: api_application_url(object.application.uid),
      name: object.application.name,
      client_id: object.application.uid
    }
  end

end