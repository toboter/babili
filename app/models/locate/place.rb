# t.string  :type
# t.text    :description
# t.integer :creator_id
# 
# t.timestamps

class Locate::Place < ApplicationRecord
  self.inheritance_column = :_type_disabled
  searchkick

  TYPES = %w(Landform Administrative Cultural PointOfInterest Route Building Archaeological)

  has_many :datings, dependent: :destroy
  has_many :toponyms, through: :datings
  has_many :events, class_name: 'Zensus::Event'
  has_many :locations, dependent: :destroy
  belongs_to :creator, class_name: "Person"

  accepts_nested_attributes_for :datings, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :events, reject_if: :all_blank, allow_destroy: true

  def default_name
    toponyms.first.try(:descriptor)
  end

  def names
    toponyms.map{ |t| t.descriptor unless t.type == 'hidden' }.join(', ')
  end

  def search_data
    { 
      type: type,
      description: description,
      name: default_name,
      datings: datings.map{ |d| d.concept.default_name }
    }
  end

  def self.sorted_by(sort_option)
    direction = ((sort_option =~ /desc$/) ? 'desc' : 'asc').to_sym
    case sort_option.to_s
    when /^updated_at_/
      { updated_at: direction }
    else
      raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  end

  def self.options_for_sorted_by
    [
      ['Updated asc', 'updated_at_asc'],
      ['Updated desc', 'updated_at_desc']
    ]
  end

end


#   def center
#     points = []
#     # raise locations.map{|x| x.loc.geometry_type.supertype }.inspect
#     locations.each do |l|
#       points << (l.loc.geometry_type.type_name == 'Point' ? l.loc : l.loc.centroid)
#     end
#     mp = RGeo::Cartesian.factory(srid: 3785).multi_point(points)
#     mp.inspect
#     # sollte mittelwert aus allen locs sein
#     # RGEO.new.point(centroid(locations.loc)
#     # Condo.order("ST_Distance(lonlat, ST_GeomFromText('#{unit.lonlat.as_text}', 4326))")
#   end
# 
#   def contains
# 
#   end
# 
#   def nearby
# 
#   end
# 
#   def within
#     # if [] nearby end
#   end
