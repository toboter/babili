module Chronoi
  class Property::Joined < Property::HadParticipant
    INVERSE_NAME = 'was joined by'

    belongs_to :joining, optional: true
    alias_method :agent, :rangeable

    # P143 joined (was joined by)
    # Domain: E85 Joining
    # Range: E39 Actor
    # Subproperty of: E5 Event. P11 had participant (participated in): E39 Actor
    # Quantification: many to many, necessary (1,n:0,n)
    # Scope note: This property identifies the instance of E39 Actor that becomes member of a E74 Group in an E85 Joining. 
  end
end