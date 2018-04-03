# Title: Category
# General: Indicates the category of which this item is an instance, preferably referring to CIDOC-CRM concept definitions.
# How to record:  CIDOC-CRM concept definitions are given at http://www.cidoccrm.org/crm-concepts/ Data values in the 
# sub-element term may often be: Man-Made Object (with conceptID "http://www.cidoc-crm.org/crm-concepts/E22"), 
# Man-Made Feature (http://www.cidoc-crm.org/crmconcepts/E25), Collection (http://www.cidoc-crm.org/crmconcepts/E78).

class Aggregation::Commit::Lido::Category
  include JsonAttribute::Model
  json_attribute :concept, Aggregation::Commit::Lido::Concerns::Types::Identifier.to_type, array: true # 0..n
  json_attribute :term, Aggregation::Commit::Lido::Concerns::Types::Term.to_type, array: true # 0..n
end