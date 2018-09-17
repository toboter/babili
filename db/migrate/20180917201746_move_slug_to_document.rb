class MoveSlugToDocument < ActiveRecord::Migration[5.2]
  def change
    remove_column :writer_categorizations, :slug, :string, index: true
    remove_column :writer_documents, :drafts_count, :integer, default: 0
    add_column :writer_documents, :slug, :string, index: true
  end
end
