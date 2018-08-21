class AddReferencesCountToVocabConcept < ActiveRecord::Migration[5.2]
  def change
    add_column :vocab_concepts, :references_count, :integer
  end
end
