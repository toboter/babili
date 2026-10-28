require_relative "../../../../lib/babili/image_processing"

module Raw::Uploader
  class ImageUploader < BaseUploader
    plugin :store_dimensions

    Attacher.validate do
      # validate dimensions only if the attached file is an image
      if validate_mime_type_inclusion Raw::Image::TYPES
        get.download do |tempfile|
          errors << "is corrupted or invalid" unless Babili::ImageProcessing.backend.valid_image?(tempfile)
        end
      end
    end

    Attacher.default_url do |options|
      "/assets/defaults/#{options[:version]}.svg"
    end


    Attacher.derivatives do |original|
      pipeline = Babili::ImageProcessing.backend.source(original).convert("jpg")

      {
        small:  pipeline.resize_to_limit!(384, 384),
        medium: pipeline.resize_to_limit!(768, 768),
        large: pipeline.resize_to_limit!(1280, 1280),
        xlarge: pipeline.resize_to_limit!(1536, 1536),
        thumb_large: pipeline.resize_to_fill!(400, 400),
        thumb_medium: pipeline.resize_to_fill!(200, 200),
        thumb_small: pipeline.resize_to_fill!(50, 50)
      }
    end


  end
end
