class CreateNamespace < ActiveRecord::Migration[5.1]
  def up
    create_table :namespaces do |t|
      t.integer   :subclass_id
      t.string    :subclass_type
      t.string    :name
      t.string    :slug
      t.timestamps
    end
    add_index :namespaces, [:subclass_id, :subclass_type]
    add_index :namespaces, :slug, unique: true
    Person.all.each do |p|
      Namespace.where(subclass_id: p.id, subclass_type: p.class.name).first_or_create(name: p.user ? (p.user.username.presence || p.slug) : p.slug)
    end
    Organization.all.each do |org|
      Namespace.where(subclass_id: org.id, subclass_type: org.class.name).first_or_create(name: org.slug)
    end
  end

  def down
    remove_index :namespaces, [:subclass_id, :subclass_type]
    remove_index :namespaces, :slug
    drop_table :namespaces
  end
end
