class CreateAccessibilities < ActiveRecord::Migration[5.0]
  def change
    create_table :accessibilities do |t|
      t.references :application, foreign_key: true
      t.references :project, foreign_key: true
      t.string :access

      t.timestamps
    end
  end
end
