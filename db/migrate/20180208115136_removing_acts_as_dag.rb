class RemovingActsAsDag < ActiveRecord::Migration[5.1]
  def up
    drop_table :vocab_descendants
    drop_table :vocab_links
    create_table :vocab_descendants, force: true do |t|
      t.string :category_type
      t.references :ancestor
      t.references :descendant
      t.integer :distance
    end

    create_table :vocab_links, force: true do |t|
      t.string :category_type
      t.references :parent
      t.references :child
    end

    
  end
  
  def down
    drop_table :vocab_descendants
    drop_table :vocab_links
    create_table :vocab_descendants, force: true do |t|
      t.string :category_type
      t.references :ancestor
      t.references :descendant
      t.integer :distance
    end

    create_table :vocab_links, force: true do |t|
      t.string :category_type
      t.references :parent
      t.references :child
    end
  end
end
