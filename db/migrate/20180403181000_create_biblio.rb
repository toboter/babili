class CreateBiblio < ActiveRecord::Migration[5.1]
  def change
    create_table :biblio_entries do |t|
      t.string   :type
      t.integer  :parent_id
      t.jsonb    :data
      t.text     :file_data
      t.integer  :creator_id
      t.string   :slug
      t.timestamps
    end
    add_index :biblio_entries, :type
    add_index :biblio_entries, :parent_id
    add_index :biblio_entries, :creator_id
    add_index :biblio_entries, :slug

    create_table :biblio_creatorships do |t|
      t.integer  :agent_appellation_id
      t.integer  :entry_id
      t.integer  :position
      t.string   :type
      t.timestamps
    end
    add_index :biblio_creatorships, :agent_appellation_id
    add_index :biblio_creatorships, :entry_id
    add_index :biblio_creatorships, :type

    create_table :biblio_entry_hierarchies, id: false do |t|
      t.integer :ancestor_id,   null: false
      t.integer :descendant_id, null: false
      t.integer :generations,   null: false
      t.index [:ancestor_id, :descendant_id, :generations], name: "biblio_entry_anc_desc_idx", unique: true, using: :btree
      t.index [:descendant_id], name: "biblio_entry_desc_idx", using: :btree
    end
    
    
  end
end