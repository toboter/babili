class CreateRawFileUploads < ActiveRecord::Migration[5.2]
  def change
    create_table :raw_file_uploads do |t|
      t.string   :slug
      t.string   :type
      t.string   :file_signature
      t.text     :file_data
      t.integer  :uploader_id
      t.string   :creator
      t.string   :file_copyright

      t.timestamps
    end
    add_index :raw_file_uploads, :slug
    add_index :raw_file_uploads, :type
    add_index :raw_file_uploads, :file_signature

  end
end
