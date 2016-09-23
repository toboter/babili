class RemoveImagesFromBlogs < ActiveRecord::Migration[5.0]
  def change
    remove_column :blogs, :images
  end
end
