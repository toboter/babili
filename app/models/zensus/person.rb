class Zensus::Person < Zensus::Agent
  has_many :groups, through: :events # conditions: 

  has_one :parent_activity, -> { where(property_id: 25).limit(1) }, as: :actable, class_name: 'Zensus::Activity'
  has_one :parent_event, -> { distinct }, through: :parent_activity, source: :event
  has_many :child_activities, -> { where(property_id: [23,24]) }, as: :actable, class_name: 'Zensus::Activity'
  has_many :child_events, -> { distinct }, through: :child_activities, source: :event

  def parents
    parent_activity.present? ? (parent_event.activities-[parent_activity]).map(&:actable) : nil
  end

  def children
    child_activities.any? ? child_events.map{|e| e.activities.where(property_id: 25).map(&:actable)}.flatten : nil
  end

  def siblings
    parents ? parents.map{|p| p.children-[self] }.flatten.uniq : nil
  end
end

# Person < Actor
# P152 has parent (is parent of): E21 Person