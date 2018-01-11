class Vocab::AAT
  extend ActiveModel::Naming
  attr_accessor :id, :slug, :type, :label, :scheme
  require 'sparql/client'

  def self.search(q)
    query = "select ?Subject ?Term ?Parents ?ScopeNote {
      ?Subject a skos:Concept; luc:term \"#{q}*\"; skos:inScheme aat: ;
         gvp:prefLabelGVP [xl:literalForm ?Term].
      optional {?Subject gvp:parentStringAbbrev ?Parents}
      optional {?Subject skos:scopeNote [dct:language gvp_lang:en; rdf:value ?ScopeNote]}
    } order by asc(lcase(str(?Term)))"
    sparql = SPARQL::Client.new("http://vocab.getty.edu/sparql")
    puts query
    sparql.query(query)
  end

  def initialize(attributes = {})
    @id = attributes[:id] || nil
    @slug = @id
    @type = attributes[:type]
    @label = attributes[:label]
    @scheme = Vocab::Scheme.find_by_abbr('aat')
  end
  
  def to_partial_path
    'vocab/concepts/concept'
  end

  def indent
    '20'
  end

  def name(lang=nil)
    label
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

  def self.facets
    query = "select * {
      ?f a gvp:Facet; 
        skos:inScheme aat: ; 
        gvp:prefLabelGVP/xl:literalForm ?l
    }"
    sparql = SPARQL::Client.new("http://vocab.getty.edu/sparql")
    concepts=[]
    puts query
    sparql.query(query).each do |s|
      concepts << Vocab::AAT.new({type: 'Facet', label: s['l'].to_s, id: s['f'].to_s.split('/').last})
    end
    concepts
  end

  def self.find(param)
    query = "CONSTRUCT {
      ?s  ?p1 ?o1. # subject
      ?ac ?p2 ?o2. # change action
      ?t  ?p3 ?o3. # term/note
      ?ss ?p4 ?o4. # subject local source
      ?ts ?p6 ?o6. # term/note local source
      ?st ?p7 ?o7. # statement about relations/types
      ?ar ?p8 ?o8. # anonymous array of subject
      ?l1 ?p9 ?o9. # list element of subject
      ?l2 ?pA ?oA. # list element of anonymous array
      ?th ?pB ?oB. # thing: place, agent
      ?tx ?pC ?oC. # thing extension: geometry, biography, event
      ?sn ?pD ?oD. # statement about nationality
    } WHERE {
      BIND (aat:#{param} as ?s) # tgn:3000034, aat:300198841
      {?s ?p1 ?o1 FILTER(!isBlank(?o1) && ?p1 != gvp:narrowerExtended && ?p1 != skos:narrowerTransitive)}
      UNION {?s skos:changeNote ?ac. ?ac ?p2 ?o2}
      UNION {?s dct:source ?ss. ?ss a bibo:DocumentPart. ?ss ?p4 ?o4}
      UNION {?s skos:scopeNote|xl:prefLabel|xl:altLabel ?t.
         {?t ?p3 ?o3 FILTER(!isBlank(?o3))}
         UNION {?t dct:source ?ts. ?ts a bibo:DocumentPart. ?ts ?p6 ?o6}}
      UNION {?st rdf:subject ?s. ?st ?p7 ?o7}
      UNION {?s skos:member/^rdf:first ?l1. ?l1 ?p9 ?o9}
      UNION {?s ^iso:superOrdinate ?ar FILTER NOT EXISTS {?ar xl:prefLabel ?t1}.
         {?ar ?p8 ?o8 FILTER(!isBlank(?o8))}
         UNION {?ar skos:member/^rdf:first ?l2. ?l2 ?pA ?oA}}
      UNION {?s foaf:focus ?th.
         {?th ?pB ?oB}
         UNION {?th schema:geo|gvp:biography|bio:event ?tx. ?tx ?pC ?oC}
         UNION {?sn rdf:subject ?th. ?sn ?pD ?oD}}
    }"
    puts query
    sparql = SPARQL::Client.new("http://vocab.getty.edu/sparql")
    concept = sparql.query(query).to_jsonld
    Vocab::AAT.new({label: concept, id: param})
  end

  def parents
    concepts=[]
    query = "select * {
      aat:#{self.id} gvp:broaderPreferred ?parent.
      ?parent gvp:prefLabelGVP/xl:literalForm ?l.
    }"
    sparql = SPARQL::Client.new("http://vocab.getty.edu/sparql")
    puts query
    sparql.query(query).each do |s|
      concepts << Vocab::AAT.new({label: s['l'].to_s, id: s['parent'].to_s.split('/').last})
    end
    concepts
  end

  def children
    concepts=[]
    query = "select * {
      ?child gvp:broaderPreferred aat:#{self.id}. 
      ?child gvp:prefLabelGVP/xl:literalForm ?l.
    }"
    sparql = SPARQL::Client.new("http://vocab.getty.edu/sparql")
    puts query
    sparql.query(query).each do |s|
      concepts << Vocab::AAT.new({label: s['l'].to_s, id: s['child'].to_s.split('/').last})
    end
    concepts
  end


end