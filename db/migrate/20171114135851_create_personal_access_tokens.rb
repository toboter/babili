class CreatePersonalAccessTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :personal_access_tokens do |t|
      t.integer :resource_owner_id
      t.string :access_token
      t.string :description
      t.jsonb :scope
      t.boolean :revoked, null: false, default: false

      t.timestamps
    end
    add_index :personal_access_tokens, :resource_owner_id
    add_index :personal_access_tokens, :access_token, unique: true
  end
end
