class AddDataPublishedColumnToProject < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :data_published, :boolean
  end
end
