class AddPrivateToRepository < ActiveRecord::Migration[5.2]
  def change
    add_column :repositories, :private, :boolean, default: false
  end
end
