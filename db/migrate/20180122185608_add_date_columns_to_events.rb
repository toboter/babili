class AddDateColumnsToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :zensus_events, :beginn_at, :datetime
    add_column :zensus_events, :ended_at, :datetime
  end
end
