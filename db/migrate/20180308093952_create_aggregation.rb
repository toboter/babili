class CreateAggregation < ActiveRecord::Migration[5.1]
  def change
    create_table :aggregation_events do |t|
      t.integer  :repository_id
      t.integer  :creator_id
      t.text     :note
      t.string   :type   # upload, api_request, list
      t.jsonb    :origin # file_data, content_type, schema(lido, table); http_request_url; list_id
      # es muss ja irgendwie sichergestellt werden dass am ende json importiert wird, 
      # vielleicht sogar nach einem zu definierende Standard. Array, weil eine Kette 
      # an zu durchlaufenden Prozessen zu erwarten ist. Bsp.: LIDO.xml to json, mapping xy.
      # saved procedures? user definded mappings?
      t.jsonb    :processors # primary_id_label || id, other_identificator_labels [], 
      t.datetime :commited_at # if present?: locked.
      t.string   :slug
      t.timestamps
    end
    add_index :aggregation_events, :repository_id
    add_index :aggregation_events, :creator_id
    add_index :aggregation_events, :type
    add_index :aggregation_events, :slug

    create_table :aggregation_commits do |t|
      t.integer  :item_id
      t.integer  :event_id
      t.integer  :origin_commit_id
      t.integer  :creator_id
      t.jsonb    :data, default: {}
      t.timestamps
    end
    add_index :aggregation_commits, :item_id
    add_index :aggregation_commits, :event_id
    add_index :aggregation_commits, :origin_commit_id
    add_index :aggregation_commits, :creator_id


    # Primärschlussel ist wichtig
    create_table :aggregation_items do |t|
      t.integer  :repository_id # das ist der index über die enthaltenen objekte
      # items listet alle eindeutigen primärschlüssel_ids eines repo auf. 
      # items : identifiers = m : n
      t.integer  :pref_identifier_id # primärer schlüssel eines dokuments; 
      # kopierte Objekte in anderen repos bekommen auch dieses element angezeigt. 
      # das es angezeigt wird ist dem vorhandensein eines commits in einem repo geschuldet.
      t.string   :type # CustomResource ArtifactResource, LiteratureResource, ArchivalResource
      t.string   :slug
      t.timestamps
    end
    add_index :aggregation_items, :repository_id
    add_index :aggregation_items, :pref_identifier_id
    add_index :aggregation_items, :type
    add_index :aggregation_items, :slug

    create_table :aggregation_identifications do |t|
      t.integer  :item_id
      t.integer  :identifier_id    
    end
    add_index :aggregation_identifications, [:item_id, :identifier_id]
    
    create_table :aggregation_identifiers do |t|
      t.string   :origin_id       # bspw. 'VA Bab 03563', '2051455', 'Bab26764.02'; 
      t.string   :origin_type     # _label bspw. 'Ident.Nr.', 'ISIL (ISO 15511)/Obj.ID', 'BabRel'
      t.string   :origin_agent_id # -> wer hat die id vergeben?; bspw. 'VAM', 'DE-MUS-815718', 'Olof Pedersén'
      t.timestamps
    end
    add_index :aggregation_identifiers, :origin_id
    
  end
end


# class CreateDatum < ActiveRecord::Migration[5.1]
#   def change
#     create_table :datum_commits do |t| # Singular, das Ereignis
#       t.integer :repository_id
#       t.integer :creator_id
#       t.string :type # types = Import, APICommit, Processing, Fork = Herkunft
#       t.jsonb :data # :file_data, :text (Import); process_all_as: Dataset.type || dataset.type || raw; mappings: [] (Processing)
#       t.text :note
#       t.timestamps
#     end
#     add_index :datum_commits, :repository_id
#     add_index :datum_commits, :creator_id
#     add_index :datum_commits, :type
# 
#     create_table :datum_sets do |t| # Plural, die Datensätze des Ereignisses
#       t.integer :repository_id
#       t.integer :creator_id
#       t.integer :origin_id # verweist auf = Dataset (closure_tree)
#       t.integer :commit_id
#       t.string :type # types = Raw ExcavationDataset ArchivalDataset MuseumDataset(Lido)
#       t.jsonb :data
#       t.timestamps
#     end
#     add_index :datum_sets, :repository_id
#     add_index :datum_sets, :creator_id
#     add_index :datum_sets, :origin_id
#     add_index :datum_sets, :commit_id
# 
#     
#   end
# end