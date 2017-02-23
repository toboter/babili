class RenameSearchAppModels < ActiveRecord::Migration[5.0]
  def change
    rename_table :applications, :oread_applications
    rename_table :accessibilities, :oread_accessibilities

    rename_column :oread_accessibilities, :application_id, :oread_application_id
    remove_column :oread_accessibilities, :access, :string
    add_column :oread_accessibilities, :creator_id, :integer

    rename_column :oread_applications, :image, :image_data
    rename_column :oread_applications, :search_url, :search_path
    add_column :oread_applications, :owner_type, :string
    add_column :oread_applications, :port, :integer
    remove_column :oread_applications, :provider, :string
    remove_column :oread_applications, :oauth_application_id, :integer
    add_index :oread_applications, [:owner_id, :owner_type], unique: true
  end
end