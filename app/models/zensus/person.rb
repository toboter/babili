class Zensus::Person < Zensus::Agent
  has_many :joining_activities, -> { where(property_id: 16) }, as: :actable, class_name: 'Zensus::Activity'
  has_many :joining_events, through: :joining_activities, source: :event

  has_one :parent_activity, -> { where(property_id: 25).limit(1) }, as: :actable, class_name: 'Zensus::Activity'
  has_one :parent_event, -> { distinct }, through: :parent_activity, source: :event
  has_many :child_activities, -> { where(property_id: [23,24]) }, as: :actable, class_name: 'Zensus::Activity'
  has_many :child_events, -> { distinct }, through: :child_activities, source: :event

  def parents
    parent_activity.present? ? (parent_event.activities-[parent_activity]).map(&:actable) : nil
  end

  def family_tree
    path + [{name: default_name, generation: 0}] + descendants
  end

  def path(depth=0)
    items=[]
    parents.map do |p|
      items << {name: p.default_name, generation: depth-1, parents: p.path(depth-1)}
    end if parents
    items
  end

  def descendants(depth=0)
    items=[]
    children.map do |c|
      items << {name: c.default_name, generation: depth+1, children: c.descendants(depth+1)}
    end if children
    items
  end

  def children
    child_activities.any? ? child_events.map{|e| e.activities.where(property_id: 25).map(&:actable)}.flatten : nil
  end

  def siblings
    parents ? parents.map{|p| p.children-[self] }.flatten.uniq : nil
  end

  def groups
    joining_events.any? ? joining_events.map{ |j| j.activities.where(property_id: 17).map(&:actable) }.flatten : nil
  end

end

# Person < Actor
# P152 has parent (is parent of): E21 Person