class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :display_name

  def display_name
    [object.honorific_prefix, object.given_name, object.family_name, object.honorific_suffix].join(' ').strip
  end

  
end