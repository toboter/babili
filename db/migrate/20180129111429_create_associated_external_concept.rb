class CreateAssociatedExternalConcept < ActiveRecord::Migration[5.1]
  def change
    remove_index :vocab_associative_relations, :related_concept_id
    
    create_table :vocab_external_concepts do |t|
      t.string  :uri
      t.string  :label
      t.timestamps
    end

    rename_column :vocab_associative_relations, :related_concept_id, :associatable_id
    rename_column :vocab_associative_relations, :value, :associatable_type
    add_index :vocab_associative_relations, [:associatable_id, :associatable_type], name: 'index_vocab_associative_relations_on_associatable'
  end
end