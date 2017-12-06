class AddHostIdToOreadApplications < ActiveRecord::Migration[5.0]
  def change
    add_column :oread_applications, :uid, :string
  end
end
