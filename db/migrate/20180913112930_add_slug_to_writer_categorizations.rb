class AddSlugToWriterCategorizations < ActiveRecord::Migration[5.2]
  def change
    add_column :writer_categorizations, :slug, :string
    add_index :writer_categorizations, :slug
  end
end
