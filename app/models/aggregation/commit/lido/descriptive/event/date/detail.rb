# Title: Date
# General: Contains a date specification by providing a set of years as earliest and latest date delimiting the 
# respective span of time. This may be a period or a set of years in the proleptic Gregorian calendar delimiting 
# the span of time. If it is an exact date, possibly with time, repeat the same date (and time) in earliest and 
# latest date.

class Aggregation::Commit::Lido::Descriptive::Event::Date::Detail
  include JsonAttribute::Model
  json_attribute :earliest, Aggregation::Commit::Lido::Concerns::Date.to_type # 0..1
  json_attribute :latest, Aggregation::Commit::Lido::Concerns::Date.to_type # 0..1
end