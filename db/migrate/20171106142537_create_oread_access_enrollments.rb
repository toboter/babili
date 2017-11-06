class CreateOreadAccessEnrollments < ActiveRecord::Migration[5.0]
  def change
    create_table :oread_access_enrollments do |t|
      t.references :enrollee, index: true, foreign_key: { to_table: :users }
      t.references :application, index: true, foreign_key: { to_table: :oread_applications }
      t.references :creator, index: true, foreign_key: { to_table: :users }

      t.timestamps
    end
    add_index :oread_access_enrollments, [:enrollee_id, :application_id], unique: true, name: 'index_oread_access_enrollments_on_enrollee_and_application'
  end
end
