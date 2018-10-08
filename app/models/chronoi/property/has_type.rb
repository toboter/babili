module Chronoi
  class Property::HasType < Property
    INVERSE_NAME = 'is type of'

    belongs_to :entity, optional: true
    alias_method :concept, :rangeable

    # P2 has type (is type of)
    # Domain: E1 CRM Entity
    # Range: E55 Type
    # Superproperty of. E1 CRM Entity.P137 exemplifies (is exemplified by):E55 Type
    # Quantification: many to many (0,n:0,n)
    # Scope note: This property allows sub typing of CRM entities - a form of specialisation – through the use of
    # a terminological hierarchy, or thesaurus.
    # The CRM is intended to focus on the high-level entities and relationships needed to describe
    # data structures. Consequently, it does not specialise entities any further than is required for this
    # immediate purpose. However, entities in the isA hierarchy of the CRM may by specialised into
    # any number of sub entities, which can be defined in the E55 Type hierarchy. E51 Contact
    # Point, for example, may be specialised into “e-mail address”, “telephone number”, “post office
    # box”, “URL” etc. none of which figures explicitly in the CRM hierarchy. Sub typing obviously
    # requires consistency between the meaning of the terms assigned and the more general intent of
    # the CRM entity in question.
    # Examples:
     # “enquiries@cidoc-crm.org” (E51) has type e-mail address (E55)
  end
end