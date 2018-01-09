class Vocab::AAT
  extend ActiveModel::Naming
  attr_reader :concept, :id
  require 'sparql/client'

  def initialize(concept, id=nil)
    @id = id
    @concept = concept
  end

  def self.factes
    query = "select * {?f a gvp:Facet; skos:inScheme aat: ; gvp:prefLabelGVP/xl:literalForm ?l}"
    sparql = SPARQL::Client.new("http://vocab.getty.edu/sparql")
    concepts=[]
    sparql.query(query).each do |s|
      concepts << new(s['l'].to_s, s['f'].to_s.split('/').last)
    end
    concepts
  end

  def self.find(param)
    query = "select ?l ?lab ?lang ?pref ?historic ?display ?pos ?type ?kind ?flag ?start ?end ?comment {
      values ?s {aat:#{param}}
      values ?pred {xl:prefLabel xl:altLabel}
      ?s ?pred ?l.
      bind (if(exists{?s gvp:prefLabelGVP ?l},\"pref GVP\",if(?pred=xl:prefLabel,\"pref\",\"\")) as ?pref)
      ?l xl:literalForm ?lab.
      optional {?l dct:language [gvp:prefLabelGVP [xl:literalForm ?lang]]}
      optional {?l gvp:displayOrder ?ord}
      optional {?l gvp:historicFlag [skos:prefLabel ?historic]}
      optional {?l gvp:termDisplay [skos:prefLabel ?display]}
      optional {?l gvp:termPOS [skos:prefLabel ?pos]}
      optional {?l gvp:termType [skos:prefLabel ?type]}
      optional {?l gvp:termKind [skos:prefLabel ?kind]}
      optional {?l gvp:termFlag [skos:prefLabel ?flag]}
      optional {?l gvp:estStart ?start}
      optional {?l gvp:estEnd ?end}
      optional {?l rdfs:comment ?comment}
    } order by ?ord"
    sparql = SPARQL::Client.new("http://vocab.getty.edu/sparql")
    new(sparql.query(query), param)
  end

  def children
    query = "select * {?x gvp:broaderExtended aat:#{self.id}; skos:inScheme aat: ; gvp:prefLabelGVP/xl:literalForm ?l} Limit 3"
    sparql = SPARQL::Client.new("http://vocab.getty.edu/sparql")
    sparql.query(query)
  end

  def to_model
    # You will get to_model error, if you don't have this dummy method
  end
  # You need this otherwise you get an error
  def persisted?
    false
  end

end