class AddActiveBooleanToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :is_active, :boolean, null: false, default: false
  end
end
