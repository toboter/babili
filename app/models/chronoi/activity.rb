module Chronoi
  class Activity < Event
    has_many :carried_out_by, class_name: 'Property::CarriedOutBy', foreign_key: :entity_id
    has_many :was_influenced_by, class_name: 'Property::WasInfluencedBy', foreign_key: :entity_id
    has_many :continued, class_name: 'Property::Continued', foreign_key: :entity_id


    # E7 Activity 
    # Subclass of: E5 Event
    # Superclass of: 
    # E8 Acquisition
    # E9 Move
    # E10 Transfer of Custody
    # E11 Modification
    # E13 Attribute Assignment
    # E65 Creation
    # E66 Formation
    # E85 Joining
    # E86 Leaving
    # E87 Curation Activity
    # Scope note: This class comprises actions intentionally carried out by instances of E39 Actor that result in
    # changes of state in the cultural, social, or physical systems documented.
    # This notion includes complex, composite and long-lasting actions such as the building of a
    # settlement or a war, as well as simple, short-lived actions such as the opening of a door.
    # Examples:
    #  the Battle of Stalingrad
    #  the Yalta Conference
    #  my birthday celebration 28-6-1995
    #  the writing of “Faust” by Goethe (E65)
    #  the formation of the Bauhaus 1919 (E66)
    #  calling the place identified by TGN ‘7017998’ ‘Quyunjig’ by the people of Iraq
    # Properties:
    # P14 carried out by (performed): E39 Actor
    # (P14.1 in the role of: E55 Type)
    # P15 was influenced by (influenced): E1 CRM Entity
    # P16 used specific object (was used for): E70 Thing
    # (P16.1 mode of use: E55 Type)
    # P17 was motivated by (motivated): E1 CRM Entity
    # P19 was intended use of (was made for): E71 Man-Made Thing
    # (P19.1 mode of use: E55 Type)
    # P20 had specific purpose (was purpose of): E5 Event
    # P21 had general purpose (was purpose of): E55 Type
    # P32 used general technique (was technique of): E55 Type
    # P33 used specific technique (was used by): E29 Design or Procedure
    # P125 used object of type (was type of object used in): E55 Type
    # P134 continued (was continued by): E7 Activity 
  end
end