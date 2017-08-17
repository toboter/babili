class RemoveProfileDataFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :about_me, :text
    remove_column :users, :birthday, :datetime
    remove_column :users, :gender, :string
    remove_column :users, :family_name, :string
    remove_column :users, :given_name, :string
    remove_column :users, :honorific_prefix, :string
    remove_column :users, :honorific_suffix, :string
    remove_column :users, :middle_name, :string
    remove_column :users, :image_data, :text
  end
end
