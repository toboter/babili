class AddIndexOnDataToBiblioEntries < ActiveRecord::Migration[5.1]
  def change
    add_index :biblio_entries, :data, using: :gin
  end
end
