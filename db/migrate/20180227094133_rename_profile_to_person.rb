class RenameProfileToPerson < ActiveRecord::Migration[5.1]
  def up
    rename_table :profiles, :people
    add_column :users, :person_id, :integer
    add_index :users, :person_id
    # rename_column :memberships, :project_id, :organization_id
    # OauthAccessibility.where(accessor_type: 'Project').update_all(accessor_type: 'Organization')
    # Membership.where(role: 'Owner').update_all(role: 'Admin')
  end
  
  def down
    rename_table :people, :profiles
    remove_index :users, :person_id
    remove_column :users, :person_id
    # rename_column :memberships, :organization_id, :project_id
    # OauthAccessibility.where(accessor_type: 'Organization').update_all(accessor_type: 'Project')
    # Membership.where(role: 'Admin').update_all(role: 'Owner')
  end
  
end
