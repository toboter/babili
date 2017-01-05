class AddOAuthApplicationIdToApplications < ActiveRecord::Migration[5.0]
  def change
    add_column :applications, :oauth_application_id, :integer
  end
end
