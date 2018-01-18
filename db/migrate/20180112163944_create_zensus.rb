class CreateZensus < ActiveRecord::Migration[5.0]
  def change
    create_table :zensus_agents do |t|
      t.string    :slug
      t.string    :type
      t.text      :address
      t.timestamps
    end
    add_index :zensus_agents, :slug, unique: true
    add_index :zensus_agents, :type

    create_table :zensus_activities do |t|
      t.integer   :event_id
      t.string    :property
      #t.integer    :property_id
      t.integer   :actable_id
      t.string    :actable_type
      t.text      :note
      t.string    :note_type
      t.timestamps
    end
    add_index :zensus_activities, :event_id
    add_index :zensus_activities, :property
    add_index :zensus_activities, [:actable_id, :actable_type]

    create_table :zensus_appellation_parts do |t|
      t.integer   :appellation_id
      t.integer   :position
      t.string    :body
      t.string    :type
      t.boolean   :preferred, null: false, default: false
      t.timestamps
    end
    add_index :zensus_appellation_parts, :appellation_id
    add_index :zensus_appellation_parts, :type
    add_index :zensus_appellation_parts, :preferred

    create_table :zensus_appellations do |t|
      t.integer   :agent_id
      t.string    :language
      t.string    :period
      t.string    :trans
      t.timestamps
    end
    add_index :zensus_appellations, :agent_id

    create_table :zensus_event_relations do |t|
      t.integer   :event_id
      t.string    :property
      t.integer   :related_event_id
      t.timestamps
    end
    add_index :zensus_event_relations, :event_id
    add_index :zensus_event_relations, :property
    add_index :zensus_event_relations, :related_event_id

    create_table :zensus_events do |t|
      t.string    :type
      t.string    :beginn
      t.string    :end
      #t.string    :ended
      t.boolean   :circa, null: false, default: false
      #t.integer   :place_id
      #t.integer   :period_id
      t.timestamps
    end
    add_index :zensus_events, :type

    create_table :zensus_links do |t|
      t.integer   :agent_id
      t.string    :uri
      t.string    :type
      t.timestamps
    end
    add_index :zensus_links, :agent_id
  end
end
