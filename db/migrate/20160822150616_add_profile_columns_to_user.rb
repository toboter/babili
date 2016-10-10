class AddProfileColumnsToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :about_me, :text
    add_column :users, :birthday, :datetime
    add_column :users, :gender, :string
    add_column :users, :family_name, :string
    add_column :users, :given_name, :string
    add_column :users, :honorific_prefix, :string
    add_column :users, :honorific_suffix, :string
    add_column :users, :middle_name, :string
    
    add_column :users, :is_admin, :boolean, null: false, default: false
  end
end
