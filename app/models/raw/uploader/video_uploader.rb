require "streamio-ffmpeg"

module Raw::Uploader
  class VideoUploader < BaseUploader

    Attacher.validate do
      validate_mime_type_inclusion Raw::Video::TYPES
    end


    Attacher.derivatives do |original|
      video = Tempfile.new(["shrine-video", ".mp4"], binmode: true)
      screenshot = Tempfile.new(["shrine-video-preview", ".mp4"], binmode: true)

      movie = FFMPEG::Movie.new(original.path)
      movie.transcode(video.path, %w(-strict -2))
      movie.screenshot(screenshot.path)
      original.delete

      magick = ImageProcessing::MiniMagick.source(screenshot)

      {
        original: video,
        preview:  magick
      }
    end

  end
end
