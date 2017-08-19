class AddAbstractToBlogs < ActiveRecord::Migration[5.0]
  def change
    add_column :blogs, :abstract, :text
  end
end
