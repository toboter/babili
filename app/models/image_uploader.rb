require "image_processing/mini_magick"

class ImageUploader < Shrine
  include ImageProcessing::MiniMagick
  plugin :processing
  plugin :versions   # enable Shrine to handle a hash of files
  plugin :delete_raw # delete processed files after uploading
  # plugin :default_url

  Attacher.default_url do |options|
    "/assets/defaults/#{options[:version]}.svg"
  end
  
  process(:store) do |io, context|
    original = io.download

    size_800 = resize_to_limit!(original, 800, 800)
    size_500 = resize_to_limit(size_800,  500, 500)
    size_300 = resize_to_limit(size_500,  300, 300)
    size_800_250 = resize_to_fill(size_800, 800, 250)
    size_650_350 = resize_to_fill(size_800, 650, 350)
    thumb_200 = resize_to_fill(size_300, 200, 200)
    thumb_100 = resize_to_fill(thumb_200, 100, 100)
    thumb_50 = resize_to_fill(thumb_100, 50, 50)

    {
      original: io, 
      large: size_800, 
      medium: size_500, 
      small: size_300,
      banner: size_800_250,
      small_banner: size_650_350,
      big_thumb: thumb_200,
      thumb: thumb_100,
      small_thumb: thumb_50
    }
  end
end
