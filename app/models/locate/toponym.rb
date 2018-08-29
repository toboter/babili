# t.integer :dating_id
# t.string  :type
# t.string  :denomination
# t.string  :descriptor
# t.string  :language
# t.integer :creator_id
# 
# t.timestamps

class Locate::Toponym < ApplicationRecord
  self.inheritance_column = :_type_disabled

  DENOMINATIONS = %w(self foreign)
  TYPES = %w(Preferred Alternative Hidden)

  belongs_to :dating, optional: true
  has_one :place, through: :dating

  alias_attribute :given, :descriptor

end