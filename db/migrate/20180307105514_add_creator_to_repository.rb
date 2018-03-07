class AddCreatorToRepository < ActiveRecord::Migration[5.1]
  def change
    add_column :repositories, :creator_id, :integer
    add_index :repositories, :creator_id
  end
end
