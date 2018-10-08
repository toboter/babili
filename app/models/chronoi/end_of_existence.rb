module Chronoi
  class EndOfExistence < Event
    has_many :took_out_of_existence, class_name: 'Property::TookOutOfExistence', foreign_key: :entity_id
      
    # E64 End of Existence
    # Subclass of: E5 Event
    # Superclass of: 
    # E6 Destruction
    # E68 Dissolution
    # E69 Death
    # E81 Transformation
    # Scope note: This class comprises events that end the existence of any E77 Persistent Item.
    # It may be used for temporal reasoning about things (physical items, groups of people, living
    # beings) ceasing to exist; it serves as a hook for determination of a terminus postquem and
    # antequem. In cases where substance from a Persistent Item continues to exist in a new form,
    # the process would be documented by E81 Transformation.
    # Examples:
    #  the death of Snoopy, my dog
    #  the melting of the snowman
    #  the burning of the Temple of Artemis in Ephesos by Herostratos in 356BC
    # Properties:
    # P93 took out of existence (was taken out of existence by): E77 Persistent Item
  end
end