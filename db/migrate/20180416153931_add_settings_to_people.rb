class AddSettingsToPeople < ActiveRecord::Migration[5.1]
  def change
    add_column :people, :settings, :jsonb
  end
end
