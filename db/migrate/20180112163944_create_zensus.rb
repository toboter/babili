class CreateZensus < ActiveRecord::Migration[5.0]
  def change
    create_table :zensus_agents do |t|
      t.string    :slug
      t.string    :type
      t.text      :address
    end

    create_table :zensus_activities do |t|
      t.integer    :event_id
      t.string     :property
      t.references :actable
      t.text       :note
      t.string     :note_type
    end

    create_table :zensus_appellation_parts do |t|
      t.integer   :appellation_id
      t.integer   :position
      t.string    :body
      t.string    :type
      t.boolean   :preferred, null: false, default: false
    end

    create_table :zensus_appellations do |t|
      t.integer   :agent_id
      t.string    :language
      t.string    :period
      t.string    :trans
    end

    create_table :zensus_event_relations do |t|
      t.integer   :event_id
      t.string    :property
      t.integer   :related_event_id
    end

    create_table :zensus_events do |t|
      t.string    :type
      t.string    :beginn
      t.string    :end
      t.boolean   :circa, null: false, default: false
    end

    create_table :zensus_links do |t|
      t.integer   :agent_id
      t.string    :uri
      t.string    :type
    end
  end
end
