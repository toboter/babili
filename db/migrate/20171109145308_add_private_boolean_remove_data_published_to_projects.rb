class AddPrivateBooleanRemoveDataPublishedToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :private, :boolean, null: false, default: false
    remove_column :projects, :data_published, :boolean, null: false, default: false
  end
end
