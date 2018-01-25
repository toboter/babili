class AddDefaultAppellationIdToZensusAgents < ActiveRecord::Migration[5.1]
  def change
    add_column :zensus_agents, :default_appellation_id, :integer
  end
end
