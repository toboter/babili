module Raw
  class Video < FileUpload
    include Uploader::VideoUploader::Attachment.new(:file)

    TYPES= %w[
      video/mpeg
      video/x-msvideo
      video/webm
      video/mp4
    ]
 
    def embed_url
      file[:original].url
    end

  end
end
