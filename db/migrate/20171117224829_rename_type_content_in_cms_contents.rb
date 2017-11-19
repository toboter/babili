class RenameTypeContentInCMSContents < ActiveRecord::Migration[5.0]
  def up
    CMS::Base.inheritance_column = false
    CMS::Base.where(type: 'About').update_all(type: 'CMS::BlogPage', type_details: {featured: true})
    CMS::Base.where(type: 'Post').update_all(type: 'CMS::BlogPage')
    CMS::Base.where(type: 'Novelity').update_all(type: 'CMS::Novelity')
  end

  def down
    CMS::Base.inheritance_column = false
    CMS::Base.where(type: 'CMS::Blog').where('type_details @> ?', {featured: true}.to_json).update_all(type: 'About')
    CMS::Base.where(type: 'CMS::Blog').update_all(type: 'Post')
    CMS::Base.where(type: 'CMS::Novelity').update_all(type: 'Novelity')
  end
end
