class CreateOauthAccessibilities < ActiveRecord::Migration[5.0]
  def change
    create_table :oauth_accessibilities do |t|
      t.references :oauth_application, foreign_key: true
      t.references :project, foreign_key: true
      t.integer :creator_id

      t.timestamps
    end
  end
end
