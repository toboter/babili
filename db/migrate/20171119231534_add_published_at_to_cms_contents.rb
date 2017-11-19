class AddPublishedAtToCMSContents < ActiveRecord::Migration[5.0]
  def up
    add_column :cms_contents, :published_at, :datetime
    CMS::BlogPage.all.map{|b| b.update(published_at: b.created_at)}
  end

  def down
    remove_column :cms_contents, :published_at
  end
end
