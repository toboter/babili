class CreateWriter < ActiveRecord::Migration[5.2]
  def change
    create_table :collaborations do |t|
      t.integer   :collaboratable_id
      t.string    :collaboratable_type
      t.integer   :collaborator_id
      t.boolean   :can_create, default: false
      t.boolean   :can_read, default: true
      t.boolean   :can_update, default: false
      t.boolean   :can_destroy, default: false
      t.boolean   :can_manage, default: false
      t.integer   :creator_id
      t.timestamps
    end
    add_index :collaborations, [:collaboratable_type, :collaboratable_id], name: 'index_collaborations_on_collaboratable'
    add_index :collaborations, :collaborator_id
    add_index :collaborations, :creator_id

    create_table :writer_documents do |t|
      t.integer   :repository_id
      t.integer   :sequential_id
      t.string    :title
      t.text      :content
      t.integer   :char_count, default: 0
      t.integer   :word_count, default: 0
      t.string    :language
      t.datetime  :published_at
      t.integer   :publisher_id
      t.integer   :creator_id
      t.jsonb     :settings
      t.integer   :drafts_count, default: 0
      t.timestamps
    end
    add_index :writer_documents, :repository_id
    add_index :writer_documents, :sequential_id
    add_index :writer_documents, [:sequential_id, :repository_id], unique: true
    add_index :writer_documents, :title
    add_index :writer_documents, :published_at
    add_index :writer_documents, :publisher_id
    add_index :writer_documents, :creator_id

    create_table :writer_category_nodes do |t|
      t.integer   :parent_id
      t.string    :type
      t.string    :slug
      t.string    :name
      t.integer   :sort_order
      t.integer   :creator_id
      t.integer   :categorization_count, default: 0
      t.timestamps
    end
    add_index :writer_category_nodes, :parent_id
    add_index :writer_category_nodes, :type
    add_index :writer_category_nodes, :slug
    add_index :writer_category_nodes, :name
    add_index :writer_category_nodes, :sort_order
    add_index :writer_category_nodes, :creator_id

    create_table :writer_categorizations do |t|
      t.integer   :category_node_id
      t.integer   :document_id
      t.integer   :categorizer_id
      t.timestamps
    end
    add_index :writer_categorizations, :category_node_id
    add_index :writer_categorizations, :document_id
    add_index :writer_categorizations, :categorizer_id

    create_table :writer_category_node_hierarchies, id: false do |t|
      t.integer :ancestor_id, null: false
      t.integer :descendant_id, null: false
      t.integer :generations, null: false
    end

    add_index :writer_category_node_hierarchies, [:ancestor_id, :descendant_id, :generations],
      unique: true,
      name: "category_node_anc_desc_idx"

    add_index :writer_category_node_hierarchies, [:descendant_id],
      name: "category_node_desc_idx"
  end
end
