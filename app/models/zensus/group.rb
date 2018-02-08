class Zensus::Group < Zensus::Agent
  has_many :joining_activities, -> { where(property_id: 144) }, as: :actable, class_name: 'Zensus::Activity'
  has_many :joining_events, through: :joining_activities, source: :event

  def members
    joining_events.any? ? joining_events.map{ |j| j.activities.where(property_id: 143).map(&:actable) }.flatten : nil
  end


end

# Group < Actor
# E40 Legal Body
# P107 has current or former member (is current or former member of): E39 Actor
# (P107.1 kind of member: E55 Type)
# 
# LegalBody < Group
# - [can act as agent]