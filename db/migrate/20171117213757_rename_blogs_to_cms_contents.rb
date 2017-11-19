class RenameBlogsToCMSContents < ActiveRecord::Migration[5.0]
  def change
    rename_table :blogs, :cms_contents
    remove_column :cms_contents, :external_link, :string
    remove_column :cms_contents, :posted_at, :datetime
    remove_column :cms_contents, :abstract, :text
    remove_column :cms_contents, :position, :integer
    add_column :cms_contents, :type_details, :jsonb
  end
end
