class RemoveUniqIndexOnSlugInCMSContents < ActiveRecord::Migration[5.0]
  def change
    remove_index :cms_contents, :slug
    add_index :cms_contents, :slug
  end
end
