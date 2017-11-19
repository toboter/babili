class RenameTypeContentInCMSContents < ActiveRecord::Migration[5.0]
  def up
    CMS::Content.inheritance_column = false
    CMS::Content.where(type: 'About').update_all(type: 'CMS::BlogPage', type_details: {featured: true})
    CMS::Content.where(type: 'Post').update_all(type: 'CMS::BlogPage')
    CMS::Content.where(type: 'Novelity').update_all(type: 'CMS::Novelity')
  end

  def down
    CMS::Content.inheritance_column = false
    CMS::Content.where(type: 'CMS::Blog').where('type_details @> ?', {featured: true}.to_json).update_all(type: 'About')
    CMS::Content.where(type: 'CMS::Blog').update_all(type: 'Post')
    CMS::Content.where(type: 'CMS::Novelity').update_all(type: 'Novelity')
  end
end
