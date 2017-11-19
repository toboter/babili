class AddPositionToCMSHelpCategories < ActiveRecord::Migration[5.0]
  def change
    add_column :cms_help_categories, :position, :integer
  end
end
