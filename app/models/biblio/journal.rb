class Biblio::Journal < Biblio::Entry
  include JsonAttribute::Record
  include JsonAttribute::Record::QueryScopes
  self.default_json_container_attribute = 'data'

  json_attribute :name, :string
  json_attribute :abbr, :string
  json_attribute :key, :string
  json_attribute :note, :string
  json_attribute :print_issn, :string

  validates :name, presence: true

  has_many :articles, class_name: 'Biblio::Article', foreign_key: :parent_id

  def name_abbr
    "#{name} #{abbr ? '('+abbr+')' : ''}"
  end

end
