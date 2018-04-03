# Title: Legal Body Weblink
# General: Weblink of the institution or person referred to as legal body.

class Aggregation::Commit::Lido::Concerns::Types::Url
  include JsonAttribute::Model
  json_attribute :value, :string
  json_attribute :label, :string
  json_attribute :lang, :string
  json_attribute :pref, :string # preferred, alternate
  json_attribute :format, :string # text/html, text/xml, image/jpeg, audio/mpeg, video/mpeg, application/pdf
end