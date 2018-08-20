# Used by Discussion::Comment.mentions

class NamespaceSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  include ApplicationHelper
  type :namespace

  attribute :gid do
    object.to_global_id.uri
  end

  attribute :name do
    object.subclass.try(:name).presence || object.name
  end

  attribute :html_url do
    namespace_url(object)
  end

  attribute :namespace do
    object.name
  end

  attribute :avatar_url do
    "http://#{Rails.application.routes.default_url_options[:host]}
    #{':'+Rails.application.routes.default_url_options[:port].to_s if Rails.application.routes.default_url_options[:port]}
    #{object.subclass.image_url(:small_thumb)}".squish.gsub(/\s+/, "") if object.subclass
  end

end
