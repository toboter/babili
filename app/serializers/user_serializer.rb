class UserSerializer < ActiveModel::Serializer
  attributes :username, :id
  attribute :email, if: :is_current_user?
  attributes :display_name, :image_thumb_50

  def display_name
    object.name
  end
  
  def image_thumb_50
    "http://#{Rails.application.routes.default_url_options[:host]}
    #{':'+Rails.application.routes.default_url_options[:port].to_s if Rails.application.routes.default_url_options[:port]}
    #{object.profile.image_url(:small_thumb)}".squish.gsub(/\s+/, "") if object.profile
  end

  def is_current_user?
    object.id == current_user.id
  end
end