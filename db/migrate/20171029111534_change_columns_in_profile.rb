class ChangeColumnsInProfile < ActiveRecord::Migration[5.0]
  def change
    add_column :profiles, :url, :string
    add_column :profiles, :institution, :string
    add_column :profiles, :location, :string
    remove_column :profiles, :birthday, :datetime
    remove_column :profiles, :gender, :string
  end
end
