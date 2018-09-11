module Raw
  class Image < FileUpload
    include Uploader::ImageUploader::Attachment.new(:file)

    TYPES = %w[
      image/gif
      image/jpeg
      image/png
      image/tiff
      image/webp
    ]
  end
end
