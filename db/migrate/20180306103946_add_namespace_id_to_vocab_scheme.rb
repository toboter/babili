class AddNamespaceIdToVocabScheme < ActiveRecord::Migration[5.1]
  def up
    add_column :vocab_schemes, :namespace_id, :integer
    remove_column :vocab_schemes, :definer_id
    remove_column :vocab_schemes, :definer_type
    add_index :vocab_schemes, :namespace_id
    Vocab::Scheme.all.each{|s| s.update(namespace_id: Namespace.all.organizations.first.id)}
  end

  def down
    remove_index :vocab_schemes, :namespace_id
    remove_column :vocab_schemes, :namespace_id
    add_column :vocab_schemes, :definer_id, :integer
    add_column :vocab_schemes, :definer_type, :string
  end
end
