class CreateJoinTableBiblioEntriesRepositories < ActiveRecord::Migration[5.1]
  def change
    create_table :biblio_referencations do |t|
      t.integer  :entry_id
      t.integer  :repository_id
      t.integer  :creator_id
      t.timestamps
    end
    add_index :biblio_referencations, :entry_id
    add_index :biblio_referencations, :repository_id
    add_index :biblio_referencations, :creator_id
  end
end
