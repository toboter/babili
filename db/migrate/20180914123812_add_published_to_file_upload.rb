class AddPublishedToFileUpload < ActiveRecord::Migration[5.2]
  def change
    add_column :raw_file_uploads, :published, :boolean, default: false
    add_column :raw_file_uploads, :published_at, :datetime
    add_column :raw_file_uploads, :publisher_id, :integer
  end
end
