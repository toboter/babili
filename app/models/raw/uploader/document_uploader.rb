module Raw::Uploader
  class DocumentUploader < BaseUploader
    plugin :validation_helpers

    Attacher.validate do
      validate_mime_type_inclusion Raw::FileUpload.types
    end

  end
end