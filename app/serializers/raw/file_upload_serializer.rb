# Used by Discussion::Comment.references

class Raw::FileUploadSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  type :file

  attribute :slug, key: :id

  attribute :gid do
    object.to_global_id.uri
  end

  attribute :file_url do
    embed = case object.type
      when 'Raw::Image' then view_raw_file_upload_path(object, version: 'large')
      when 'Raw::Document' then view_raw_file_upload_path(object, version: 'preview')
      when 'Raw::Video' then view_raw_file_upload_path(object, version: 'preview')
      when 'Raw::Audio' then view_raw_file_upload_path(object, version: 'original')
      else view_raw_file_upload_path(object, version: 'original')
      end

    embed
  end

  attribute :html_url do
    raw_file_upload_url(object)
  end

end
