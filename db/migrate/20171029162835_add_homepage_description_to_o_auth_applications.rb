class AddHomepageDescriptionToOAuthApplications < ActiveRecord::Migration[5.0]
  def change
    add_column :oauth_applications, :homepage_url, :string
    add_column :oauth_applications, :description, :string
  end
end
