class AddSlugToCMSHelpAndBlogCategory < ActiveRecord::Migration[5.0]
  def change
    add_column :cms_blog_categories, :slug, :string
    add_column :cms_help_categories, :slug, :string
    add_index :cms_blog_categories, :slug, unique: true
    add_index :cms_help_categories, :slug, unique: true
  end
end
