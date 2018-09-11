module Api::V1
  class PersonSerializer < ActiveModel::Serializer
    include Rails.application.routes.url_helpers
    type :person

    attributes :name, :id, :namespace, :avatar_url, :url, :html_url, :organizations_url, :repositories_url, :vocabularies_url, :applications_url, :type, :site_admin

    def avatar_url
      "#{Rails.application.routes.default_url_options[:host]}
      #{':'+Rails.application.routes.default_url_options[:port].to_s if Rails.application.routes.default_url_options[:port]}
      #{object.image_url(:small_thumb)}".squish.gsub(/\s+/, "")
    end

    def namespace
      object.namespace.name
    end

    def url
      v1_person_url(object)
    end

    def html_url
      namespace_url(object.namespace)
    end

    def organizations_url
      organizations_v1_person_url(object)
    end

    def repositories_url
      v1_namespace_repositories_url(object.namespace)
    end

    def vocabularies_url
      v1_namespace_vocab_schemes_url(object.namespace)
    end

    def applications_url
      nil
    end

    def type
      'Person'
    end

    def site_admin
      object.is_admin?
    end

  end
end