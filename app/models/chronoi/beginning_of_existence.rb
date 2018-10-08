module Chronoi
  class BeginningOfExistence < Event
    has_many :brought_into_existence, class_name: 'Property::BroughtIntoExistence', foreign_key: :entity_id

    # E63 Beginning of Existence
    # Subclass of: E5 Event
    # Superclass of: 
    # E12 Production
    # E65 Creation
    # E66 Formation
    # E67 Birth
    # E81 Transformation
    # Scope note: This class comprises events that bring into existence any E77 Persistent Item.
    # It may be used for temporal reasoning about things (intellectual products, physical items,
    # groups of people, living beings) beginning to exist; it serves as a hook for determination of a
    # terminus post quem and ante quem.
    # Examples:
    #  the birth of my child
    #  the birth of Snoopy, my dog
    #  the calving of the iceberg that sank the Titanic
    #  the construction of the Eiffel Tower
    # Properties:
    # P92 brought into existence (was brought into existence by): E77 Persistent Item 
  end
end