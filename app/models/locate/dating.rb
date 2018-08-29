# t.integer :place_id
# t.string  :dating_gid
# 
# t.timestamps

class Locate::Dating < ApplicationRecord
  belongs_to :place, optional: true
  belongs_to :concept, class_name: 'Vocab::Concept', foreign_key: :dating_id, optional: true
  has_many :toponyms, dependent: :destroy
  has_and_belongs_to_many :locations

  accepts_nested_attributes_for :toponyms, reject_if: :all_blank, allow_destroy: true
end