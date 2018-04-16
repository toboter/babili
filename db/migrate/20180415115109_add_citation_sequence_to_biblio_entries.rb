class AddCitationSequenceToBiblioEntries < ActiveRecord::Migration[5.1]
  def change
    add_column :biblio_entries, :citation_raw, :string
    add_column :biblio_entries, :sequential_id, :integer
    add_index :biblio_entries, [:citation_raw, :sequential_id], unique: true
  end
end
