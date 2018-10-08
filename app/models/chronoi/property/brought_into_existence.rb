module Chronoi
  class Property::BroughtIntoExistence < Property::OccuredInThePresenceOf
    INVERSE_NAME = 'was brought into existence by'
    
    belongs_to :beginning_of_existence, optional: true
    alias_method :persistent_item, :rangeable

    # P92 brought into existence (was brought into existence by)
    # Domain: E63 Beginning of Existence
    # Range: E77 Persistent Item
    # Subproperty of: E5 Event. P12 occurred in the presence of (was present at): E77 Persistent Item
    # Superproperty of: E65 Creation. P94 has created (was created by): E28 Conceptual Object
    # E66 Formation. P95 has formed (was formed by): E74 Group
    # E67 Birth. P98 brought into life (was born): E21 Person
    # E12 Production. P108 has produced (was produced by): E24 Physical Man-Made Thing
    # E81 Transformation. P123 resulted in (resulted from): E77 Persistent Item
    # Quantification: one to many, necessary, dependent (1,n:1,1)
    # Scope note: This property allows an E63 Beginning of Existence event to be linked to the E77 Persistent Item brought into existence by it. 
  end
end