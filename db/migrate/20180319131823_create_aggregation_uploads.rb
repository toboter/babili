class CreateAggregationUploads < ActiveRecord::Migration[5.1]
  def change
    create_table :aggregation_uploads do |t|
      t.integer :event_id
      t.text :file_data
      t.timestamps
    end
    add_index :aggregation_uploads, :event_id
  end
end
