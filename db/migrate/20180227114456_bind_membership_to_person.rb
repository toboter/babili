class BindMembershipToPerson < ActiveRecord::Migration[5.1]
  def up
    add_column :memberships, :person_id, :integer
    add_index :memberships, :person_id, unique: false
    Membership.all.each do |m|
      p_id = User.find(m.user_id).person_id
      m.update(person_id: p_id)
    end
    remove_index :memberships, :user_id
    remove_column :memberships, :user_id
  end
  
  def down
    add_column :memberships, :user_id, :integer
    add_index :memberships, :user_id, unique: false
    Membership.all.each do |m|
      u_id = Person.find(m.person_id).user.id
      m.update(user_id: u_id)
    end
    remove_index :memberships, :person_id
    remove_column :memberships, :person_id
  end
end
