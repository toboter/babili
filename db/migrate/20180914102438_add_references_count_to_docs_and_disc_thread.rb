class AddReferencesCountToDocsAndDiscThread < ActiveRecord::Migration[5.2]
  def change
    add_column :writer_documents, :references_count, :integer, default: 0
    add_column :discussion_threads, :references_count, :integer, default: 0
  end
end
