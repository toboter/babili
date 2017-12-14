class CreateRepositoryClasses < ActiveRecord::Migration[5.0]
  def change
    create_table :repository_classes do |t|
      t.string :repo_api_url
      t.integer :repository_id

      t.timestamps
    end
  end
end
