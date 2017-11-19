class CreateCMSContentHierarchies < ActiveRecord::Migration
  def change
    create_table :cms_content_hierarchies, id: false do |t|
      t.integer :ancestor_id, null: false
      t.integer :descendant_id, null: false
      t.integer :generations, null: false
    end

    add_index :cms_content_hierarchies, [:ancestor_id, :descendant_id, :generations],
      unique: true,
      name: "cms_base_anc_desc_idx"

    add_index :cms_content_hierarchies, [:descendant_id],
      name: "cms_base_desc_idx"
  end
end
