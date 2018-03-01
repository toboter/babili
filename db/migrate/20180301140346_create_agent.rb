class CreateAgent < ActiveRecord::Migration[5.1]
  def up
    create_table :agents do |t|
      t.integer   :subclass_id
      t.string    :subclass_type
      t.string    :name
      t.string    :slug
    end
    add_index :agents, [:subclass_id, :subclass_type]
    add_index :agents, :slug, unique: true
    Person.all.each do |p|
      Agent.where(subclass_id: p.id, subclass_type: p.class.name).first_or_create(name: p.user ? (p.user.username.presence || p.slug) : p.slug)
    end
    Organization.all.each do |org|
      Agent.where(subclass_id: org.id, subclass_type: org.class.name).first_or_create(name: org.slug)
    end
  end

  def down
    remove_index :agents, [:subclass_id, :subclass_type]
    remove_index :agents, :slug
    drop_table :agents
  end
end
