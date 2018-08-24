class AddReferencesCountToBiblioEntry < ActiveRecord::Migration[5.2]
  def change
    add_column :biblio_entries, :references_count, :integer
  end
end
