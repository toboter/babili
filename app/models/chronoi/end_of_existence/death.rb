module Chronoi
  class EndOfExistence::Death < EndOfExistence
    has_one :was_death_of, class_name: 'Property::WasDeathOf', foreign_key: :entity_id

    validates :was_death_of, presence: true

    # E69 Death
    # Subclass of: E64 End of Existence
    # Scope note: This class comprises the deaths of human beings. 
    # If a person is killed, their death should be instantiated as E69 Death and as E7 Activity. The 
    # Definition of the CIDOC Conceptual Reference Model 28
    # death or perishing of other living beings should be documented using E64 End of Existence. 
    # Properties:
    # P100 was death of (died in): E21 Person 
  end
end