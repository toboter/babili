# techreport entry
# A report published by a school or other institution, usually numbered within a series.
# 
# Format:
# 
#      @TECHREPORT{citation_key,
#                  required_fields [, optional_fields] }
# Required fields: author, title, institution, year
# 
# Optional fields: type, number, address, month, note, key

class Biblio::Techreport < Biblio::Entry
  include JsonAttribute::Record
  include JsonAttribute::Record::QueryScopes
  self.default_json_container_attribute = 'data'

  CREATOR_TYPES = %w(Author)

  has_many :creatorships, dependent: :destroy, class_name: 'Biblio::Creatorship', foreign_key: :entry_id
  has_many :authors, through: :creatorships, source: :agent_appellation
  json_attribute :title, :string
  json_attribute :institution_id, :integer
  json_attribute :year, :string

  json_attribute :subtype, :string
  belongs_to :serie, class_name: 'Biblio::Serie', foreign_key: :parent_id, optional: true
  json_attribute :number, :string
  json_attribute :place_ids, :integer, array: true
  json_attribute :month, :string
  json_attribute :note, :string
  json_attribute :key, :string
  
  json_attribute :url, :string
  json_attribute :doi, :string
  json_attribute :abstract, :string

  validates :authors, :title, :institution_id, :year, presence: true

  def institution
    institution_id.present? ? Zensus::Agent.find(institution_id) : nil
  end

  def places
    place_ids.present? ? Locate::Place.find(place_ids) : []
  end

  accepts_nested_attributes_for :serie, reject_if: :all_blank, allow_destroy: false

end