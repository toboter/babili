module Raw::Uploader
  class VideoUploader < BaseUploader
    plugin :validation_helpers

    Attacher.validate do
      validate_mime_type_inclusion Raw::Video::TYPES
    end

  end
end