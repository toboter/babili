module Chronoi
  class Property::BroughtIntoLife < Property::BroughtIntoExistence
    INVERSE_NAME = 'was born'
    
    belongs_to :birth, optional: true
    alias_method :person, :rangeable

    # P98 brought into life (was born)
    # Domain: E67 Birth
    # Range: E21 Person
    # Subproperty of: E63 Beginning of Existence. P92 brought into existence (was brought into existence by): E77
    # Persistent Item
    # Quantification: one to many, dependent (0,n:1,1)
    # Scope note: This property links an E67Birth event to an E21 Person in the role of offspring
  end
end