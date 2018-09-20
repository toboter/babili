class AddAgentIdToPerson < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :agent_id, :integer, index: true, unique: true
    remove_column :people, :honorific_prefix, :string
    remove_column :people, :honorific_suffix, :string
    remove_column :people, :slug, :string, index: true, unique: true
    remove_column :people, :user_id, :integer, index: true
    remove_column :people, :url, :string
    remove_column :people, :institution, :string
    remove_column :people, :location, :string
  end
end