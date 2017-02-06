class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :about_me, :birthday, :gender, :display_name, :name
  has_many :projects, serializer: ProjectSerializer
  
  def name
    { 
      family_name: object.family_name, 
      given_name: object.given_name, 
      honorific_prefix: object.honorific_prefix, 
      honorific_suffix: object.honorific_suffix, 
      middle_name: object.middle_name
    }
  end

  def display_name
    [object.honorific_prefix, object.given_name, object.family_name, object.honorific_suffix].join(' ').strip
  end
  

  
  # def url
  #   profile_url(object)
  # end
  
  # def image
  #  {
  #    thumb_sm_url: object.thumbxyz
  #    thumb_md_url: object.thumbxyz
  #    thumb_lg_url: object.thumbxyz
  #  }
  # end
end