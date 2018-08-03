module Api::V1
  class OrganizationSerializer < ActiveModel::Serializer
    include Rails.application.routes.url_helpers
    type :organization

    attributes :name, :id, :namespace, :url, :html_url, :members_url, :repositories_url, :vocabularies_url, :avatar_url, :description

    attributes :member_ids, :oauth_application_uids

    def namespace
      object.namespace.name
    end

    def url
      v1_organization_url(object)
    end

    def html_url
      namespace_url(object.namespace)
    end

    def members_url
      v1_organization_members_url(object)
    end

    def repositories_url
      v1_namespace_repositories_url(object.namespace)
    end

    def vocabularies_url
      v1_namespace_vocab_schemes_url(object.namespace)
    end

    def avatar_url
      "http://#{Rails.application.routes.default_url_options[:host]}
      #{':'+Rails.application.routes.default_url_options[:port].to_s if Rails.application.routes.default_url_options[:port]}
      #{object.image_url(:small_thumb)}".squish.gsub(/\s+/, "")
    end

    def member_ids
      object.members.order(id: :asc).map{|m| m.user.id} if object.members.any?
    end

    def oauth_application_uids
      object.accessible_oauth_apps.map(&:uid) if object.accessible_oauth_apps.any?
    end

  end
end