class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :display_name, :image_thumb_50

  def display_name
    object.name
  end
  
  def image_thumb_50
    "http://#{Rails.application.routes.default_url_options[:host]}
    #{':'+Rails.application.routes.default_url_options[:port].to_s if Rails.application.routes.default_url_options[:port]}
    #{object.profile.image_url(:small_thumb)}".squish.gsub(/\s+/, "") if object.profile
  end

end