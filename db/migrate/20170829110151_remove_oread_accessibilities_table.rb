class RemoveOreadAccessibilitiesTable < ActiveRecord::Migration[5.0]
  def up
    drop_table :oread_accessibilities
  end

  def down
    create_table :oread_accessibilities do |t|
      t.integer :oread_application_id
      t.integer :creator_id
      t.integer :project_id

      t.timestamps
    end
    add_index :oread_accessibilities, :oread_application_id
    add_index :oread_accessibilities, :project_id
  end

end