module Raw
  class Audio < FileUpload
    include Uploader::AudioUploader::Attachment.new(:file)

    TYPES = %w[
      audio/x-mpeg
      audio/mpeg
      audio/x-wav
      audio/webm
      audio/mp3
    ]

    def embed_url
      file[:original].url
    end

  end
end