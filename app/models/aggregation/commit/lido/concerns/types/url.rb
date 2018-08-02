# Title: Legal Body Weblink
# General: Weblink of the institution or person referred to as legal body.

class Aggregation::Commit::Lido::Concerns::Types::Url
  include AttrJson::Model
  attr_json :value, :string
  attr_json :label, :string
  attr_json :lang, :string
  attr_json :pref, :string # preferred, alternate
  attr_json :format, :string # text/html, text/xml, image/jpeg, audio/mpeg, video/mpeg, application/pdf
end