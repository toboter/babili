class MembershipSerializer < ActiveModel::Serializer
  attributes :name, :provider, :user_id, :role
  
  def provider
    'babili'
  end
  
  def name
    object.user.try(:display_name)
  end

end