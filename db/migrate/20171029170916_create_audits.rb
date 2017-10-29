class CreateAudits < ActiveRecord::Migration[5.0]
  def change
    create_table :audits do |t|
      t.references :user, foreign_key: true
      t.references :actor, references: :users
      t.string :action
      t.text :action_description
      t.string :actor_ip

      t.timestamps
    end
  end
end
