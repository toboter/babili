class Zensus::Group < Zensus::Agent
  has_many :members, through: :events # conditions: event.where(p_itemable_type: 'Zensus::Agent')
end

# Group < Actor
# E40 Legal Body
# P107 has current or former member (is current or former member of): E39 Actor
# (P107.1 kind of member: E55 Type)
# 
# LegalBody < Group
# - [can act as agent]