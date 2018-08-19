module  Raw
  class Audio < FileUpload
    include Uploader::AudioUploader::Attachment.new(:file)

    TYPES = %w[
      audio/x-mpeg
      audio/x-wav
      audio/webm
    ]
  end

  def default_url
    file.url
  end
end
