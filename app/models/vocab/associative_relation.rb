# t.integer   :id
# t.integer   :concept_id
# t.string    :property
# t.integer   :associatable_id
# t.string    :associatable_type

class Vocab::AssociativeRelation < ApplicationRecord
  attr_accessor :associated_concept
  belongs_to :concept, class_name: "Concept"
  belongs_to :associatable, polymorphic: true
  
  validates :property, :associatable, presence: true

  def self.properties
    %w(close exact related broader narrower)
  end

  def associated_concept
    associatable
  end

  def associated_concept=(params)
    gid,name = params.split(',')
    if GlobalID::Locator.locate gid
      self.associatable = GlobalID::Locator.locate(gid)
    else
      ext_concept = Vocab::ExternalConcept.create(uri: gid, label: name)
      self.associatable = ext_concept
    end
  end

end