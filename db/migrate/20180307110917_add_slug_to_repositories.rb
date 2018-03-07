class AddSlugToRepositories < ActiveRecord::Migration[5.1]
  def change
    add_column :repositories, :slug, :string
    add_index :repositories, :slug
  end
end
