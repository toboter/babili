class AddOwnerToApplication < ActiveRecord::Migration[5.0]
  def change
    add_column :applications, :owner_id, :integer
  end
end
