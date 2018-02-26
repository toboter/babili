class RenameProjectToOrganization < ActiveRecord::Migration[5.1]
  def up
    rename_table :projects, :organizations
    rename_column :memberships, :project_id, :organization_id
    OauthAccessibility.where(accessor_type: 'Project').update_all(accessor_type: 'Organization')
    Membership.where(role: 'Owner').update_all(role: 'Admin')
  end

  def down
    rename_table :organizations, :projects
    rename_column :memberships, :organization_id, :project_id
    OauthAccessibility.where(accessor_type: 'Organization').update_all(accessor_type: 'Project')
    Membership.where(role: 'Admin').update_all(role: 'Owner')
  end

end
