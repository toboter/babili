class AddFieldsToApplications < ActiveRecord::Migration[5.0]
  def change
    add_column :applications, :description, :text
    add_column :applications, :provider, :string
    add_column :applications, :image, :string
  end
end
