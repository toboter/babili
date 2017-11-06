class AddEnrollDefaultToOreadApplications < ActiveRecord::Migration[5.0]
  def change
    add_column :oread_applications, :enroll_users_default, :boolean, null: false, default: true
  end
end
