module Chronoi
  class EndOfExistence::Dissolution < EndOfExistence
    has_one :dissolved, class_name: 'Property::Dissolved', foreign_key: :entity_id

    # E68 Dissolution
    # Subclass of: E64 End of Existence
    # Scope note: This class comprises the events that result in the formal or informal termination of an E74 Group of people.
    # If the dissolution was deliberate, the Dissolution event should also be instantiated as an E7 Activity.
    # Properties:
    # P99 dissolved (was dissolved by): E74 Group 
  end
end