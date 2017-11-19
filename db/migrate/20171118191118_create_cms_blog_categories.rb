class CreateCMSBlogCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :cms_blog_categories do |t|
      t.string :name

      t.timestamps
    end
  end
end
