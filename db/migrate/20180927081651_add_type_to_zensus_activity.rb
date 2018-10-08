class AddTypeToZensusActivity < ActiveRecord::Migration[5.2]
  def change
    add_column :zensus_activities, :type, :string
    add_index :zensus_activities, :type
  end
end
