class CreateLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :locate_places do |t|
      t.string  :type         # Settlement, Hydrological, Landform, AdministrativeArea, CulturalDiffusionArea, PointOfInterest, Route, Building, ArchaeologicalArea
      t.text    :description
      t.integer :creator_id
      
      t.timestamps
    end
    add_index :locate_places, :type
    add_index :locate_places, :creator_id
    
    create_table :locate_datings do |t|
      t.integer :place_id
      t.integer  :dating_id
    
      t.timestamps
    end
    add_index :locate_datings, :place_id
    add_index :locate_datings, :dating_id
    
    create_table :locate_toponyms do |t|
      t.integer :dating_id
      t.string  :type         # Preferred, Alternative, Hidden
      t.string  :denomination # Self, Foreign
      t.string  :descriptor
      t.string  :language
      t.integer :creator_id
    
      t.timestamps
    end
    add_index :locate_toponyms, :dating_id
    add_index :locate_toponyms, :type
    add_index :locate_toponyms, :creator_id

    create_table :locate_locations do |t|
      t.integer  :place_id
      t.geometry :loc, srid: 3785
      t.float    :fuzzyness   # km
      t.integer  :creator_id
    
      t.timestamps
    end
    add_index :locate_locations, :place_id
    add_index :locate_locations, :loc, using: :gist
    add_index :locate_locations, :creator_id
    

    create_table :locate_datings_locations, id: false do |t|
      t.integer :dating_id
      t.integer :location_id
    end
    add_index :locate_datings_locations, :dating_id
    add_index :locate_datings_locations, :location_id
    
  end
end
