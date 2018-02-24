# t.integer    :id
# t.string     :uuid
# t.integer    :scheme_id
# t.string     :type [Facet Concept GuideTerm Hierarchy]
# t.integer    :creator_id
# t.string     :status
# t.string     :slug
# has_many :broader_concepts
# has_many :narrower_concepts
# has_many :matches
# belongs_to :scheme
# belongs_to :creator [contributors]
# has_many :labels
# has_many :notes
# has_many :definitions

class Vocab::AATConcept
  extend ActiveModel::Naming
  attr_accessor :id, :slug, :type, :labels, :scheme
  require 'sparql/client'

  def initialize(attributes = {})
    @id = attributes[:id] || nil
    @slug = @id
    @type = attributes[:type]
    @labels = attributes[:labels]
    @scheme = Vocab::Scheme.find_by_abbr('aat')
  end
  
  def to_partial_path
    'vocab/concepts/concept'
  end

  def indent
    '20'
  end

  def name(lang=nil)
    labels
  end

  def root?
    type == 'Facet'
  end

  def to_model
    self
  end
  
  def persisted?
    false
  end

  def self.search(q)
    query = "select ?Subject ?Term ?Parents ?ScopeNote {
      ?Subject luc:term \"#{q}*\"; skos:inScheme aat: ;
         gvp:prefLabelGVP [xl:literalForm ?Term].
      optional {?Subject gvp:parentStringAbbrev ?Parents}
      optional {?Subject skos:scopeNote [dct:language gvp_lang:en; rdf:value ?ScopeNote]}
    } order by asc(lcase(str(?Term)))"
    sparql = SPARQL::Client.new("http://vocab.getty.edu/sparql")
    puts query
    sparql.query(query)
  end

  def self.facets(lang=nil)
    query = "select * {
      ?subject a gvp:Facet; 
        skos:inScheme aat: ; 
        xl:prefLabel|xl:altLabel [dct:language gvp_lang:#{lang.iso_639_1}; xl:literalForm ?label]
    }"
    # xl:prefLabel|xl:altLabel [dct:language gvp_lang:#{lang.iso_639_1}; xl:literalForm ?l]
    sparql = SPARQL::Client.new("http://vocab.getty.edu/sparql")
    concepts=[]
    puts query
    sparql.query(query).each_solution do |s|
      concepts << Vocab::AATConcept.new({type: 'Facet', labels: s.label.to_s, id: s.subject.to_s.split('/').last})
    end
    concepts
  end

  def self.find(id, lang=nil)
    labels=[]
    query = "select ?l ?lab ?lang ?pref ?historic ?display ?pos ?type ?kind ?flag ?start ?end ?comment {
      values ?s {aat:#{id}}
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

    puts query
    sparql = SPARQL::Client.new("http://vocab.getty.edu/sparql")
    concept = sparql.query(query).each_solution do |s|
      labels << {type: s.pref.to_s, body: s.lab.to_s, language: s.lang.to_s}
    end
    Vocab::AATConcept.new({labels: JSON.parse(labels.to_json, object_class: OpenStruct), id: id})
  end

  def parents
    concepts=[]
    query = "select * {
      aat:#{self.id} gvp:broaderPreferred ?parent.
      ?parent gvp:prefLabelGVP/xl:literalForm ?label.
    }"
    sparql = SPARQL::Client.new("http://vocab.getty.edu/sparql")
    puts query
    sparql.query(query).each_solution do |s|
      concepts << Vocab::AATConcept.new({labels: s.label.to_s, id: s.parent.to_s.split('/').last})
    end
    concepts
  end

  def children
    concepts=[]
    query = "select * {
      ?child gvp:broaderPreferred aat:#{self.id}. 
      ?child gvp:prefLabelGVP/xl:literalForm ?label.
    }"
    sparql = SPARQL::Client.new("http://vocab.getty.edu/sparql")
    puts query
    sparql.query(query).each_solution do |s|
      concepts << Vocab::AATConcept.new({labels: s.label.to_s, id: s.child.to_s.split('/').last})
    end
    concepts
  end


end