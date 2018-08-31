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
      
    process(:store) do |io, context|
      versions = { original: io } # retain original
    
      io.download do |original|
        pipeline = ImageProcessing::MiniMagick.source(original).convert("jpg")
    
        versions[:xlarge]       = pipeline.resize_to_limit!(1536, 1536)
        versions[:large]        = pipeline.resize_to_limit!(1280, 1280)
        versions[:medium]       = pipeline.resize_to_limit!(768, 768)
        versions[:small]        = pipeline.resize_to_limit!(384, 384)
        versions[:thumb_large]  = pipeline.resize_to_fill!(400, 400)
        versions[:thumb_medium] = pipeline.resize_to_fill!(200, 200)
        versions[:thumb_small]  = pipeline.resize_to_fill!(50, 50)
      end
    
      versions
    end

  end
end

    
