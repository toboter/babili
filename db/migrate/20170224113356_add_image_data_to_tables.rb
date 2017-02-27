class AddImageDataToTables < ActiveRecord::Migration[5.0]
  def change
    remove_column :oread_applications, :image_data, :string
    add_column :oread_applications, :image_data, :text
    add_column :users, :image_data, :text
  end
end
