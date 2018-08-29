require "image_processing/mini_magick"

module Raw::Uploader
  class ImageUploader < BaseUploader
    plugin :processing
    plugin :versions   # enable Shrine to handle a hash of files
    plugin :delete_raw # delete processed files after uploading
    plugin :validation_helpers
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
        pipeline = ImageProcessing::MiniMagick.source(original)
    
        versions[:large]        = pipeline.resize_to_limit!(800, 800)
        versions[:medium]       = pipeline.resize_to_limit!(500, 500)
        versions[:small]        = pipeline.resize_to_limit!(300, 300)
        versions[:banner]       = pipeline.resize_to_fill!(800, 250)
        versions[:small_banner] = pipeline.resize_to_fill!(650, 350)
        versions[:big_thumb]    = pipeline.resize_to_fill!(200, 200)
        versions[:thumb]        = pipeline.resize_to_fill!(100, 100)
        versions[:small_thumb]  = pipeline.resize_to_fill!(50, 50)
      end
    
      versions
    end

  end
end