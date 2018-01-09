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
    end

    create_table :vocab_concepts do |t|
      t.string     :uuid
      t.integer    :scheme_id
      t.integer    :creator_id
      t.string     :type
      t.string     :status
      t.string     :slug
    end

    create_table :vocab_labels do |t|
      t.integer   :concept_id
      t.string    :type
      t.string    :vernacular
      t.string    :historical
      t.string    :body
      t.string    :language
      t.boolean   :is_abbrevation
      t.integer   :creator_id
    end

    create_table :vocab_notes do |t|
      t.integer   :concept_id
      t.string    :type
      t.text      :body
      t.string    :language
      t.integer   :creator_id
    end

    create_table :vocab_associative_relations do |t|
      t.integer   :concept_id
      t.string    :property
      t.integer   :related_concept_id
      t.string    :value
    end

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
