class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :display_name, :image_thumb_50

  def display_name
    object.name
  end
  
  def image
    object.profile.image(:small_thumb) if object.profile
  end

end