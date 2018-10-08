module Chronoi
  class BeginningOfExistence::Production < BeginningOfExistence
    has_many :has_produced, class_name: 'Property::HasProduced', foreign_key: :entity_id

    # E12 Production
    # Subclass of: E11 Modification
    # E63 Beginning of Existence
    # Scope note: This class comprises activities that are designed to, and succeed in, creating one or more new
    # items.
    # It specializes the notion of modification into production. The decision as to whether or not an
    # object is regarded as new is context sensitive. Normally, items are considered “new” if there is
    # no obvious overall similarity between them and the consumed items and material used in their
    # production. In other cases, an item is considered “new” because it becomes relevant to
    # documentation by a modification. For example, the scribbling of a name on a potsherd may 
    # Definition of the CIDOC Conceptual Reference Model 8
    # make it a voting token. The original potsherd may not be worth documenting, in contrast to the
    # inscribed one.
    # This entity can be collective: the printing of a thousand books, for example, would normally be
    # considered a single event.
    # An event should also be documented using E81 Transformation if it results in the destruction
    # of one or more objects and the simultaneous production of others using parts or material from
    # the originals. In this case, the new items have separate identities and matter is preserved, but
    # identity is not.
    # Examples:
    #  the construction of the SS Great Britain
    #  the first casting of the Little Mermaid from the harbour of Copenhagen
    #  Rembrandt’s creating of the seventh state of his etching “Woman sitting half dressed
    # beside a stove”, 1658, identified by Bartsch Number 197 (E12,E65,E81)
    # Properties:
    # P108 has produced (was produced by): E24 Physical Man-Made Thing 
  end
end