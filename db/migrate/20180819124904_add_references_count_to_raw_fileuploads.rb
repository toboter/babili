class AddReferencesCountToRawFileuploads < ActiveRecord::Migration[5.2]
  def change
    add_column :raw_file_uploads, :references_count, :integer
  end
end
