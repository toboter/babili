class VocabZensusUserToPerson < ActiveRecord::Migration[5.1]
  def up
    add_column :zensus_agents, :creator_id, :integer
    add_column :zensus_events, :creator_id, :integer
    add_index :zensus_agents, :creator_id, unique: false
    add_index :zensus_events, :creator_id, unique: false
    Zensus::Agent.all.each{|a| a.update(creator_id: Person.first.id)}
    Zensus::Event.all.each{|e| e.update(creator_id: Person.first.id)}
    Vocab::Concept.all.each do |c|
      pid = User.find(c.creator_id).person_id
      c.update(creator_id: pid)
    end
    Vocab::Label.all.each do |c|
      pid = User.find(c.creator_id).person_id
      c.update(creator_id: pid)
    end
    Vocab::Note.all.each do |c|
      pid = User.find(c.creator_id).person_id
      c.update(creator_id: pid)
    end
    Vocab::Scheme.all.each do |c|
      pid = User.find(c.creator_id).person_id
      c.update(creator_id: pid)
    end
  end
  
  def down
    remove_index :zensus_agents, :creator_id
    remove_index :zensus_events, :creator_id
    remove_column :zensus_agents, :creator_id
    remove_column :zensus_events, :creator_id
    Vocab::Concept.all.each do |c|
      uid = Person.find(c.creator_id).user.id
      c.update(creator_id: uid)
    end
    Vocab::Label.all.each do |c|
      uid = Person.find(c.creator_id).user.id
      c.update(creator_id: uid)
    end
    Vocab::Note.all.each do |c|
      uid = Person.find(c.creator_id).user.id
      c.update(creator_id: uid)
    end
    Vocab::Scheme.all.each do |c|
      uid = Person.find(c.creator_id).user.id
      c.update(creator_id: uid)
    end

  end
end
