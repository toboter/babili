require "streamio-ffmpeg"

module Raw::Uploader
  class VideoUploader < BaseUploader

    Attacher.validate do
      validate_mime_type_inclusion Raw::Video::TYPES
    end

    process(:store) do |io, context|
      original_file = io.download
      video         = Tempfile.new(["shrine-video", ".mp4"], binmode: true)
      screenshot    = Tempfile.new(["shrine-video-preview", ".mp4"], binmode: true)
      movie         = FFMPEG::Movie.new(original_file.path)

      movie.transcode(video.path, %w(-strict -2))
      movie.screenshot(screenshot.path)
      original_file.delete

      versions = { original: video }
      versions[:preview] = screenshot if screenshot && screenshot.size > 0

      versions
    end

  end
end