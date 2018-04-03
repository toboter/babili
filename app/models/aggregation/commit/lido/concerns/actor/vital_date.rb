# Title: Vital Dates Actor
# General: The lifespan of the person or the existence of the corporate body or group.
# How to record: For individuals, record birth date as earliest and death date as latest date, estimated where 
# necessary. For a corporate body or group, record the dates of founding and dissolution. Although this is not a 
# mandatory field the use of birth date and death date is strongly recommended for unambigous identification
# of individuals. The type attribute of earliest and latest date may specify for indiviudals, if birth and death 
# dates or if dates of activity are recorded. Data values for type attribute may include: birthDate, 
# deathDate, estimatedDate.

class Aggregation::Commit::Lido::Concerns::Actor::VitalDate
  include JsonAttribute::Model
  json_attribute :earliest, Aggregation::Commit::Lido::Concerns::Types::Date.to_type # 0..1
  json_attribute :latest, Aggregation::Commit::Lido::Concerns::Types::Date.to_type # 0..1
end