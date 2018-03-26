class AddTypeToAggregationCommit < ActiveRecord::Migration[5.1]
  def change
    add_column :aggregation_commits, :type, :string
    add_index :aggregation_commits, :type
  end
end
