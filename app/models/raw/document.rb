module  Raw
  class Document < FileUpload
    include Uploader::DocumentUploader::Attachment.new(:file)

    TYPES = %w[
      application/pdf 
      application/rtf 
      application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
      application/vnd.openxmlformats-officedocument.wordprocessingml.document
      application/vnd.openxmlformats-officedocument.presentationml.presentation
      text/csv
      text/plain
      text/richtext
      text/rtf
    ]

    def default_url
      file.url
    end
  end
end
