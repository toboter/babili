class CreateCMSContentLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :cms_content_links do |t|
      t.text :body
      t.integer :page_id

      t.timestamps
    end
  end
end
