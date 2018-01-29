# t.integer   :id
# t.string    :uri
# t.string    :label

class Vocab::ExternalConcept < ApplicationRecord
  has_many :object_matches, as: :associatable

  validates :uri, presence: true

  def name
    label
  end

  def api_uri
    uri
  end
end