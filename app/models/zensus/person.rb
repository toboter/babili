module Zensus
  class Person < Agent
    has_one :person, class_name: '::Person', foreign_key: :agent_id
    
    has_one :brought_into_life, as: :rangeable, class_name: 'Chronoi::Property::BroughtIntoLife'
    has_one :birth, through: :brought_into_life, class_name: 'Chronoi::BeginningOfExistence::Birth', source: :entity
    delegate :father, :mother, to: :birth
    has_many :from_father, as: :rangeable, class_name: 'Chronoi::Property::FromFather'
    has_many :fatherships, through: :from_father, class_name: 'Chronoi::BeginningOfExistence::Birth', source: :entity
    has_many :by_mother, as: :rangeable, class_name: 'Chronoi::Property::ByMother'
    has_many :motherships, through: :by_mother, class_name: 'Chronoi::BeginningOfExistence::Birth', source: :entity
    
    has_one :was_death_of, as: :rangeable, class_name: 'Chronoi::Property::WasDeathOf'
    has_one :death, through: :was_death_of, class_name: 'Chronoi::EndOfExistence::Death', source: :entity

    has_many :joined, as: :rangeable, class_name: 'Chronoi::Property::Joined'
    has_many :joinings, through: :joined, class_name: 'Chronoi::Activity::Joining', source: :entity
    has_many :separated, as: :rangeable, class_name: 'Chronoi::Property::Separated'
    has_many :separations, through: :separated, class_name: 'Chronoi::Activity::Leaving', source: :entity

    accepts_nested_attributes_for :birth

    def parents
      birth ? [father].concat([mother]) : []
    end
    
    def children
      motherships.collect(&:children).concat(fatherships.collect(&:children)).flatten
    end

    def siblings
      parents ? parents.map{|p| p.children-[self] }.flatten.uniq : nil
    end

    def family_tree
      path + [{name: default_name, generation: 0}] + descendants
    end

    def path(depth=0)
      items=[]
      parents.map do |p|
        items << {name: p.default_name, generation: depth-1, parents: p.path(depth-1)} if p
      end if parents
      items
    end

    def descendants(depth=0)
      items=[]
      children.map do |c|
        items << {name: c.default_name, generation: depth+1, children: c.descendants(depth+1)} if c
      end if children
      items
    end

    def current_or_former_groups
      joinings ? joinings.collect(&:groups).flatten : []
    end

    def current_groups
      counts = separations.collect(&:groups).flatten.inject(Hash.new(0)) { |h, v| h[v] += 1; h }
      current_or_former_groups.reject { |e| counts[e] -= 1 unless counts[e].zero? }
    end

    # Person < Actor
    # P152 has parent (is parent of): E21 Person
  end
end