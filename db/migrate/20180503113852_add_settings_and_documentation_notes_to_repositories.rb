class AddSettingsAndDocumentationNotesToRepositories < ActiveRecord::Migration[5.1]
  def change
    add_column :repositories, :settings, :jsonb
    add_column :repositories, :readme, :text
  end
end
