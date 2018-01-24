class RenameZensusEventDateColumns < ActiveRecord::Migration[5.1]
  def change
    rename_column :zensus_events, :beginn_at, :begins_at_date
    rename_column :zensus_events, :ended_at, :ends_at_date
    rename_column :zensus_events, :beginn, :begins_at_string
    rename_column :zensus_events, :ended, :ends_at_string
  end
end
