module Chronoi
  class Property::TookOutOfExistence < Property::OccuredInThePresenceOf
    INVERSE_NAME = 'was taken out of existence by'

    belongs_to :end_of_existence, class_name: 'Chronoi::EndOfExistence', foreign_key: :entity_id, optional: true
    alias_method :persistent_item, :rangeable

    def self.rangeable
      [Zensus::Person, Zensus::Group]
    end

    # P93 took out of existence (was taken out of existence by)
    # Domain: E64 End of Existence
    # Range: E77 Persistent Item
    # Subproperty of: E5 Event. P12 occurred in the presence of (was present at): E77 Persistent Item
    # Superproperty of: E6 Destruction. P13 destroyed (was destroyed by): E18 Physical Thing
    # E68 Dissolution. P99 dissolved (was dissolved by): E74 Group
    # E69 Death. P100 was death of (died in): E21 Person
    # E81 Transformation. P124 transformed (was transformed by): E77 Persistent Item
    # Quantification: one to many, necessary (1,n:0,1)
    # Scope note: This property allows an E64 End of Existence event to be linked to the E77 Persistent Item
    # taken out of existence by it.
    # In the case of immaterial things, the E64 End of Existence is considered to take place with the
    # destruction of the last physical carrier. 
  end
end