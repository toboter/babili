class AddParentIdToCMSContents < ActiveRecord::Migration[5.0]
  def change
    add_column :cms_contents, :parent_id, :integer
  end
end
