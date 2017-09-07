class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :display_name

  def display_name
    object.name
  end
  
end