class CreateRepositories < ActiveRecord::Migration[5.1]
  def change
    create_table :repositories do |t|
      t.integer   :namespace_id
      t.string    :name
      t.text      :description
      t.timestamps
    end
    add_index :repositories, :namespace_id
  end
end
