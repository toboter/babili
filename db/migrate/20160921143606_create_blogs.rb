class CreateBlogs < ActiveRecord::Migration[5.0]
  def change
    create_table :blogs do |t|
      t.string :type
      t.integer :author_id
      t.string :title
      t.text :content
      t.string :external_link
      t.datetime :posted_at
      t.string :images, array: true, default: [] # add images column as array

      t.timestamps
    end
  end
end
