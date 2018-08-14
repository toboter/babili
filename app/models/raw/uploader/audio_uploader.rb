module Raw::Uploader
  class AudioUploader < BaseUploader
    plugin :validation_helpers

    Attacher.validate do
      validate_mime_type_inclusion Raw::FileUpload.types
    end

  end
end