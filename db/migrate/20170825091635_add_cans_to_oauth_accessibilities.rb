class AddCansToOauthAccessibilities < ActiveRecord::Migration[5.0]
  def change
    remove_index :oauth_accessibilities, :project_id
    remove_column :oauth_accessibilities, :project_id, :integer

    add_column :oauth_accessibilities, :accessor_id, :integer
    add_column :oauth_accessibilities, :accessor_type, :string
    add_column :oauth_accessibilities, :can_manage, :boolean, null: false, default: false
    add_column :oauth_accessibilities, :can_create, :boolean, null: false, default: false
    add_column :oauth_accessibilities, :can_read, :boolean, null: false, default: false
    add_column :oauth_accessibilities, :can_update, :boolean, null: false, default: false
    add_column :oauth_accessibilities, :can_destroy, :boolean, null: false, default: false
    add_column :oauth_accessibilities, :can_comment, :boolean, null: false, default: false
    add_column :oauth_accessibilities, :can_publish, :boolean, null: false, default: false

    add_index :oauth_accessibilities, [:accessor_id, :accessor_type]
  end
end
