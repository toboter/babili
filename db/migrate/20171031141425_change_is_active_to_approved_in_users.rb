class ChangeIsActiveToApprovedInUsers < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :is_active, :approved
    add_index  :users, :approved
  end
end
