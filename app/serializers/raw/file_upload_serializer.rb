class Raw::FileUploadSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  type :file

  attribute :slug, key: :id

  attribute :file_url do
    object.default_url
  end

  attribute :html_url do
    raw_file_upload_url(object)
  end

  attribute :type do
    object.class.name
  end
end
