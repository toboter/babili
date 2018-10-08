module Chronoi
  class Property::ByMother < Property::HadParticipant
    INVERSE_NAME = 'gave birth'

    belongs_to :birth, optional: true
    alias_method :person, :rangeable

    # P96 by mother (gave birth)
    # Domain: E67 Birth
    # Range: E21 Person
    # Subproperty of: E5 Event. P11 had participant (participated in): E39 Actor
    # Quantification: many to one, necessary (1,1:0,1) 
    # Definition of the CIDOC Conceptual Reference Model 62
    # Scope note: This property links an E67 Birth event to an E21 Person as a participant in the role of birthgiving mother. 
  end
end