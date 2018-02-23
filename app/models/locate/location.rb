# t.integer  :place_id
# t.geometry :loc, srid: 3785
# t.float    :fuzzyness   # km
# t.integer  :creator_id
# 
# t.timestamps

class Locate::Location < ApplicationRecord
  belongs_to :place
  has_and_belongs_to_many :datings


end