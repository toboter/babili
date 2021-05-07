require 'exiftool'

module Raw::Uploader
  class BaseUploader < Shrine
    plugin :instrumentation
    plugin :determine_mime_type, analyzer: :marcel
    plugin :signature
    plugin :add_metadata
    plugin :metadata_attributes
    plugin :pretty_location
    plugin :validation_helpers
    plugin :processing
    plugin :versions
    plugin :delete_raw

    add_metadata do |io, context|
      e = Exiftool.new(io.path)
      file = e.to_hash
      file.merge!({md5: calculate_signature(io, :md5)})
    end

    Attacher.metadata_attributes :copyright => :copyright, :md5 => :signature

  end
end
