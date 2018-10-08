module Chronoi
  class Property::Separated < Property::HadParticipant
    INVERSE_NAME = 'left by'

    belongs_to :leaving, optional: true
    alias_method :agent, :rangeable

    # P145 separated (left by)
    # Domain: E86 Leaving
    # Range: E39 Actor
    # Subproperty of: E5 Event. P11 had participant (participated in): E39 Actor
    # Quantification: many to many, necessary (1,n:0,n)
    # Scope note: This property identifies the instance of E39 Actor that leaves an instance of E74 Group through an instance of E86 Leaving. 
  end
end