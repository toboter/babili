class RemoveUniqueIndexFromOwnerInOreadApplication < ActiveRecord::Migration[5.0]
  def up
    remove_index :oread_applications, [:owner_id, :owner_type]
    add_index :oread_applications, [:owner_id, :owner_type], unique: false
  end

  def down
    remove_index :oread_applications, [:owner_id, :owner_type]
    add_index :oread_applications, [:owner_id, :owner_type], unique: true
  end
end
