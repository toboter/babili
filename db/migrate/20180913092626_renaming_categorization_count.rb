class RenamingCategorizationCount < ActiveRecord::Migration[5.2]
  def change
    rename_column :writer_category_nodes, :categorization_count, :categorizations_count
  end
end
