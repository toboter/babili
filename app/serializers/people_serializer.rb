class PeopleSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  include ApplicationHelper
  type :person

  attribute :name

  attribute :html_url do
    namespace_url(object.namespace)
  end

  attribute :namespace do
    object.namespace.name
  end

  attribute :avatar_url do
    "http://#{Rails.application.routes.default_url_options[:host]}
    #{':'+Rails.application.routes.default_url_options[:port].to_s if Rails.application.routes.default_url_options[:port]}
    #{object.image_url(:small_thumb)}".squish.gsub(/\s+/, "") if object
  end

end
