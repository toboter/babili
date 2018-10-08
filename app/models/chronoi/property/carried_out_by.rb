module Chronoi
  class Property::CarriedOutBy < Property::HadParticipant
    INVERSE_NAME = 'performed'

    belongs_to :activity, optional: true
    alias_method :agent, :rangeable

    # P14 carried out by (performed)
    # Domain: E7 Activity
    # Range: E39 Actor
    # Subproperty of: E5 Event. P11 had participant (participated in): E39 Actor
    # Superproperty of: E8 Acquisition. P22 transferred title to (acquired title through): E39 Actor
    # E8 Acquisition. P23 transferred title from (surrendered title through): E39 Actor
    # E10 Transfer of Custody. P28 custody surrendered by (surrendered custody through): E39 Actor
    # E10 Transfer of Custody. P29 custody received by (received custody through): E39 Actor
    # Quantification: many to many, necessary (1,n:0,n)
    # Scope note: This property describes the active participation of an E39 Actor in an E7 Activity. 
  end
end