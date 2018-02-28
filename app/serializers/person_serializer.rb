class PersonSerializer < ActiveModel::Serializer
  attributes :username, :id
  attributes :name, :image_thumb_50

  def image_thumb_50
    "http://#{Rails.application.routes.default_url_options[:host]}
    #{':'+Rails.application.routes.default_url_options[:port].to_s if Rails.application.routes.default_url_options[:port]}
    #{object.image_url(:small_thumb)}".squish.gsub(/\s+/, "")
  end

end