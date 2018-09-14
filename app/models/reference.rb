# Eine reference bindet an ein referencing object. Es kann sich um ein Vocab::Concept, Zensus::Agent, 
# Biblio::Entry, Disscussion::Thread, Aggregation::Identifier, Locate::Place handeln.

# referencing_id:integer
# referencing_type:string
# referenceabel_id:integer
# referenceable_type:string
# referencor_id:integer

class Reference < ApplicationRecord
  belongs_to :referencing, polymorphic: true # from
  belongs_to :referenceable, polymorphic: true, counter_cache: true # to
  belongs_to :referencor, class_name: 'Person'
  

  def referenceable_url
    case referenceable_type
      when 'Vocab::Concept' then [referenceable.try(:scheme).try(:namespace), :vocab, referenceable.try(:scheme), referenceable]
      when 'Writer::Document' then [referenceable.try(:repository).try(:owner), referenceable.try(:repository), referenceable]
      when 'Discussion::Thread' then [referenceable.try(:discussable).try(:owner), referenceable.try(:discussable), :discussion, referenceable]
      else [referenceable]
    end
  end

  def referencing_url
    case referencing_type
      when 'Discussion::Comment' then [referencing.thread.discussable.owner, referencing.thread.discussable, :discussion, referencing.thread, anchor: "discussion-comment-#{referencing.id}"]
      when 'Writer::Document' then [referencing.try(:repository).try(:owner), referencing.try(:repository), referencing]
      else [referencing]
    end
  end

  def referencing_gid
    referencing.try(:to_global_id).try(:to_s)
  end

  def referenceable_gid
    referenceable.try(:to_global_id).try(:to_s)
  end

  def referenceable_gid=(value)
    self.referenceable = GlobalID::Locator.locate(value)
  end

end