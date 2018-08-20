# Used by Discussion::Comment.references

class Raw::FileUploadSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  type :file

  attribute :slug, key: :id

  attribute :gid do
    object.to_global_id.uri
  end

  attribute :file_url do
    object.default_url
  end

  attribute :html_url do
    raw_file_upload_url(object)
  end

end
