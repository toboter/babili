module Chronoi
  class Property::WasDeathOf < Property::TookOutOfExistence
    INVERSE_NAME = 'died in'

    belongs_to :death, class_name: 'Chronoi::EndOfExistence::Death', foreign_key: :entity_id, optional: true
    alias_method :person, :rangeable

    def self.rangeable
      Zensus::Person
    end

    # P100 was death of (died in)
    # Domain: E69 Death 
    # Range: E21 Person
    # Subproperty of: E64 End of Existence. P93 took out of existence (was taken out of existence by): E77 Persistent Item
    # Quantification: one to many, necessary (1,n:0,n)
    # Scope note: This property links an E69 Death event to the E21 Person that died. 
  end
end