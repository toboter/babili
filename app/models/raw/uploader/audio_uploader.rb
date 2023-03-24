module Raw::Uploader
  class AudioUploader < BaseUploader

    Attacher.validate do
      validate_mime_type_inclusion Raw::Audio::TYPES
    end

    Attacher.derivatives do |original|
      transcoded = Tempfile.new ["transcoded", ".mp3"]

      audio = FFMPEG::Movie.new(original.path)
      audio.transcode(transcoded.path, %w(-vn -ar 44100 -ac 2 -codec:a libmp3lame -b:a 128k))

      {
        original: original,
        transcoded: transcoded
      }
    end

  end
end
