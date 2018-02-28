class UserToPersonInOauthAccessibilities < ActiveRecord::Migration[5.1]
  def up
    OauthAccessibility.where(accessor_type: 'User').each do |a|
      p = User.find(a.accessor_id).person
      a.update(accessor: p)
    end
    OauthAccessibility.all.each do |a|
      pid = User.find(a.creator_id).person_id
      a.update(creator_id: pid)
    end
  end
  
  def down
    OauthAccessibility.where(accessor_type: 'Person').each do |a|
      u = Person.find(a.accessor_id).user
      a.update(accessor: u)
    end
    OauthAccessibility.all.each do |a|
      uid = Person.find(a.creator_id).user.id
      a.update(creator_id: uid)
    end
  end
end
