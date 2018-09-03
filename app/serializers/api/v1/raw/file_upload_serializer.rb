module Api
  module V1
    module Raw
      class FileUploadSerializer < ActiveModel::Serializer
        include Rails.application.routes.url_helpers
        type :file

        attribute :slug, key: :id

        attribute :gid do
          object.to_global_id.uri
        end

        attribute :file_url do
          url = []
          url << "http://#{Rails.application.routes.default_url_options[:host]}"
          url << "#{':'+Rails.application.routes.default_url_options[:port].to_s}" if Rails.application.routes.default_url_options[:port]
          url << object.embed_url
          url.join('')
        end

        attribute :html_url do
          raw_file_upload_url(object)
        end

      end
    end
  end
end