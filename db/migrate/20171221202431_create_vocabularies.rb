class CreateVocabularies < ActiveRecord::Migration[5.0]
  def change
    create_table :vocab_schemes do |t|
      t.string    :abbr
      t.string    :title
      t.text      :definition
      t.integer   :definer_id
      t.string    :definer_type
      t.integer   :creator_id
      t.string    :slug
      t.timestamps
    end
    add_index :vocab_schemes, :slug, unique: true
    add_index :vocab_schemes, :abbr
    add_index :vocab_schemes, :creator_id

    create_table :vocab_concepts do |t|
      t.string     :uuid
      t.integer    :scheme_id
      t.integer    :creator_id
      t.string     :type
      t.string     :status
      t.string     :slug
      t.timestamps
    end
    add_index :vocab_concepts, :slug, unique: true
    add_index :vocab_concepts, :uuid, unique: true
    add_index :vocab_concepts, :creator_id
    add_index :vocab_concepts, :scheme_id
    add_index :vocab_concepts, :type

    create_table :vocab_labels do |t|
      t.integer   :concept_id
      t.string    :type
      t.string    :vernacular
      t.string    :historical
      t.string    :body
      t.string    :language
      t.boolean   :is_abbrevation
      t.integer   :creator_id
      t.timestamps
    end
    add_index :vocab_labels, :concept_id
    add_index :vocab_labels, :type
    add_index :vocab_labels, :creator_id

    create_table :vocab_notes do |t|
      t.integer   :concept_id
      t.string    :type
      t.text      :body
      t.string    :language
      t.integer   :creator_id
      t.timestamps
    end
    add_index :vocab_notes, :concept_id
    add_index :vocab_notes, :type
    add_index :vocab_notes, :creator_id

    create_table :vocab_associative_relations do |t|
      t.integer   :concept_id
      t.string    :property
      t.integer   :related_concept_id
      t.string    :value
      t.timestamps
    end
    add_index :vocab_associative_relations, :concept_id
    add_index :vocab_associative_relations, :related_concept_id

    create_table :vocab_descendants, force: true do |t|
      t.string :category_type
      t.references :ancestor
      t.references :descendant
      t.integer :distance
    end

    create_table :vocab_links, force: true do |t|
      t.string :category_type
      t.references :parent
      t.references :child
    end
  end
end
