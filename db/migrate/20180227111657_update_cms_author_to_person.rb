class UpdateCMSAuthorToPerson < ActiveRecord::Migration[5.1]
  def up
    Person.all.each do |p|
      User.find(p.user_id).update(person_id: p.id)
    end
    CMS::Content.all.each do |c|
      p_id = User.find(c.author_id).person.id
      c.update(author_id: p_id)
    end
  end
  
  def down
    CMS::Content.all.each do |c|
      u_id = Person.find(c.author_id).user.id
      c.update(author_id: u_id)
    end
  end
end
