class AccessibilitySerializer < ActiveModel::Serializer
  attributes :oauth_uid, :oauth_owner_id, :access
  
  def oauth_uid
    object.application.oauth_application ? object.application.oauth_application.uid : nil
  end
  
  def oauth_owner_id
    object.application.oauth_application ? object.application.oauth_application.owner.id : nil
  end
  
end