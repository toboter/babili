class AddHostToApplications < ActiveRecord::Migration[5.0]
  def change
    add_column :applications, :host, :string
  end
end
