class CreateProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :profiles do |t|
      t.references :user, foreign_key: true
      t.text :about_me
      t.datetime :birthday
      t.string :gender
      t.string :family_name
      t.string :given_name
      t.string :honorific_prefix
      t.string :honorific_suffix
      t.text :image_data

      t.timestamps
    end
  end
end
