module Zensus
  class Group < Agent
    has_many :gained_member_activities, as: :rangeable, class_name: 'Chronoi::Property::JoinedWith'
    has_many :joining_events, through: :gained_member_activities, class_name: 'Chronoi::Activity::Joining', source: :entity

    has_many :lost_member_activities, as: :rangeable, class_name: 'Chronoi::Property::SeparatedFrom'
    has_many :leaving_events, through: :lost_member_activities, class_name: 'Chronoi::Activity::Leaving', source: :entity

    has_one :formation_activity, as: :rangeable, class_name: 'Chronoi::Property::HasFormed'
    has_one :formation, through: :formation_activity, class_name: 'Chronoi::BeginningOfExistence::Formation', source: :entity 

    has_one :dissolution_activity, as: :rangeable, class_name: 'Chronoi::Property::Dissolved'
    has_one :dissolution, through: :dissolution_activity, class_name: 'Chronoi::EndOfExistence::Dissolution', source: :entity 

    def current_or_former_members
      joining_events.any? ? joining_events.map{ |e| e.joiners }.flatten : []
    end

    def former_members
      leaving_events.any? ? leaving_events.map{ |e| e.separators }.flatten : []
    end

    def current_members
      counts = former_members.inject(Hash.new(0)) { |h, v| h[v] += 1; h }
      current_or_former_members.reject { |e| counts[e] -= 1 unless counts[e].zero? }
    end


  end
end

# Group < Actor
# E40 Legal Body
# P107 has current or former member (is current or former member of): E39 Actor
# (P107.1 kind of member: E55 Type)
# 
# LegalBody < Group
# - [can act as agent]