require "image_processing/mini_magick"

module Raw::Uploader
  class ImageUploader < BaseUploader
    plugin :store_dimensions

    Attacher.validate do
      # validate dimensions only if the attached file is an image
      if validate_mime_type_inclusion Raw::Image::TYPES
        get.download do |tempfile|
          errors << "is corrupted or invalid" unless ImageProcessing::MiniMagick.valid_image?(tempfile)
        end
      end
    end

    Attacher.default_url do |options|
      "/assets/defaults/#{options[:version]}.svg"
    end


    Attacher.derivatives do |original|
      magick = ImageProcessing::MiniMagick.source(original).convert("jpg")

      {
        original: original,
        small:  magick.resize_to_limit!(384, 384),
        medium: magick.resize_to_limit!(768, 768),
        large: magick.resize_to_limit!(1280, 1280),
        xlarge: magick.resize_to_limit!(1536, 1536),
        thumb_large: magick.resize_to_fill!(400, 400),
        thumb_medium: magick.resize_to_fill!(200, 200),
        thumb_small: magick.resize_to_fill!(50, 50)
      }
    end


  end
end
