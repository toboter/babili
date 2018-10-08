module Chronoi
  class Property::HasCreated < Property::BroughtIntoExistence
    INVERSE_NAME = 'was created by'

    belongs_to :creation, optional: true
    alias_method :conceptual_object, :rangeable

    # P94 has created (was created by)
    # Domain: E65 Creation
    # Range: E28 Conceptual Object
    # Subproperty of: E63 Beginning of Existence. P92 brought into existence (was brought into existence by): E77
    # Persistent Item
    # Superproperty of: E83 Type Creation. P135 created type (was created by): E55 Type
    # Quantification: one to many, necessary, dependent (1,n:1,1)
    # Scope note: This property allows a conceptual E65 Creation to be linked to the E28 Conceptual Object created by it.
    # It represents the act of conceiving the intellectual content of the E28 Conceptual Object. It
    # does not represent the act of creating the first physical carrier of the E28 Conceptual Object. As
    # an example, this is the composition of a poem, not its commitment to paper.
    # Examples:
    #  the composition of “The Four Friends” by A. A. Milne (E65) has created “The Four
    # Friends” by A. A. Milne (E28) 
  end
end