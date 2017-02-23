class CreateOreadAccessTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :oread_access_tokens do |t|
      t.integer :resource_owner_id
      t.integer :application_id
      t.string :token
      t.string :refresh_token
      t.integer :expires_in
      t.string :token_type

      t.timestamps
    end
    add_index :oread_access_tokens, :resource_owner_id
    add_index :oread_access_tokens, :token
    add_index :oread_access_tokens, :refresh_token
  end
end
