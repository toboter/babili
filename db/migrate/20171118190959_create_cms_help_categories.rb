class CreateCMSHelpCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :cms_help_categories do |t|
      t.string :name

      t.timestamps
    end
    add_column :cms_contents, :category_id, :integer
  end
end
