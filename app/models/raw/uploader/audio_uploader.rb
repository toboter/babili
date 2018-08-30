module Raw::Uploader
  class AudioUploader < BaseUploader

    Attacher.validate do
      validate_mime_type_inclusion Raw::Audio::TYPES
    end

    process(:store) do |io, context|
      versions = { original: io }

      versions
    end

  end
end