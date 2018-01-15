class Zensus::Person < Zensus::Agent
  has_many :groups, through: :events # conditions: event.where(p_itemable_type: 'Zensus::Agent')
  has_many :parents, through: :events
  has_many :children, through: :events
end

# Person < Actor
# P152 has parent (is parent of): E21 Person