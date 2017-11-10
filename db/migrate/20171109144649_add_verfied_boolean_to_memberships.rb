class AddVerfiedBooleanToMemberships < ActiveRecord::Migration[5.0]
  def up
    add_column :memberships, :verified, :boolean, null: false, default: false
    Membership.all.each{|m| m.update(verified: true)}
  end

  def down
    remove_column :memberships, :verified
  end
end
