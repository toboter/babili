class RenameEvents < ActiveRecord::Migration[5.2]
  def up
    rename_table :zensus_events, :chronoi_entities
    add_column :chronoi_entities, :title, :string
    add_column :chronoi_entities, :note, :text
    remove_column :chronoi_entities, :place_id
    remove_column :chronoi_entities, :period_id

    rename_table :zensus_activities, :chronoi_properties
    remove_column :chronoi_properties, :property_id
    remove_column :chronoi_properties, :note_type
    rename_column :chronoi_properties, :event_id, :entity_id
    rename_column :chronoi_properties, :actable_id, :rangeable_id
    rename_column :chronoi_properties, :actable_type, :rangeable_type

    drop_table :zensus_event_relations
  end

  def down
    rename_table :chronoi_entities, :zensus_events
    remove_column :zensus_events, :title
    remove_column :zensus_events, :note
    add_column :zensus_events, :place_id, index: true
    add_column :zensus_events, :period_id, index: true

    rename_table :chronoi_properties, :zensus_activities
    add_column :zensus_activities, :property_id, :integer, index: true
    add_column :zensus_activities, :note_type, :string
    rename_column :zensus_activities, :entity_id, :event_id
    rename_column :zensus_activities, :rangeable_id, :actable_id
    rename_column :zensus_activities, :rangeable_type, :actable_type

    create_table :zensus_event_relations do |t|
      t.integer   :event_id
      t.integer   :property_id
      t.integer   :related_event_id
      t.timestamps
    end
    add_index :zensus_event_relations, :event_id
    add_index :zensus_event_relations, :property_id
    add_index :zensus_event_relations, :related_event_id
  end
end
