module Chronoi
  class Property::WasInfluencedBy < Property
    INVERSE_NAME = 'influenced'

    belongs_to :activity, class_name: 'Chronoi::Activity', foreign_key: :entity_id, optional: true
    # alias_method :crm_entity, :rangeable

    def self.rangeable
      [Zensus::Agent, Vocab::Concept, Biblio::Entry]
    end

    # P15 was influenced by (influenced)
    # Domain: E7 Activity
    # Range: E1 CRM Entity
    # Superproperty of: E7 Activity. P16 used specific object (was used for): E70 Thing
    # E7 Activity. P17 was motivated by (motivated): E1 CRM Entity
    # E7 Activity. P134 continued (was continued by): E7 Activity
    # E83 Type Creation. P136 was based on (supported type creation): E1 CRM Entity
    # Quantification: many to many (0,n:0,n)
    # Scope note: This is a high level property, which captures the relationship between an E7 Activity and anything that may have had some bearing upon it. 
  end
end