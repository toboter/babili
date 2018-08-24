require "image_processing/mini_magick"

class ImageUploader < Shrine
  plugin :processing
  plugin :determine_mime_type
  plugin :versions   # enable Shrine to handle a hash of files
  plugin :delete_raw # delete processed files after uploading
  # plugin :default_url

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