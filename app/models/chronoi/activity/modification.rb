module Chronoi
  class Activity::Modification < Activity
    has_many :has_modified, class_name: 'Property::HasModified', foreign_key: :entity_id
    has_many :employed, class_name: 'Property::Employed', foreign_key: :entity_id

    # E11 Modification
    # Subclass of: E7 Activity
    # Superclass of: E12 Production
    # E79 Part Addition
    # E80 Part Removal
    # Scope note: This class comprises all instances of E7 Activity that create, alter or change E24 Physical ManMade
    # Thing.
    # This class includes the production of an item from raw materials, and other so far
    # undocumented objects, and the preventive treatment or restoration of an object for
    # conservation.
    # Since the distinction between modification and production is not always clear, modification is
    # regarded as the more generally applicable concept. This implies that some items may be
    # consumed or destroyed in a Modification, and that others may be produced as a result of it. An
    # event should also be documented using E81 Transformation if it results in the destruction of
    # one or more objects and the simultaneous production of others using parts or material from the
    # originals. In this case, the new items have separate identities.
    # If the instance of the E29 Design or Procedure utilized for the modification prescribes the use
    # of specific materials, they should be documented using property P68 foresees use of (use
    # foreseen by): E57 Material of E29 Design or Procedure, rather than via P126 employed (was
    # employed in): E57 Material.
    # Examples:
    #  the construction of the SS Great Britain (E12)
    #  the impregnation of the Vasa warship in Stockholm for preservation after 1956
    #  the transformation of the Enola Gay into a museum exhibit by the National Air and Space
    # Museum in Washington DC between 1993 and 1995 (E12, E81)
    #  the last renewal of the gold coating of the Toshogu shrine in Nikko, Japan
    # Properties:
    # P31 has modified (was modified by): E24 Physical Man-Made Thing
    # P126 employed (was employed in): E57 Material 
  end
end