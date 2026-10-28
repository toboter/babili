# frozen_string_literal: true

# ActiveStorage boot hides ruby-vips (libvips < 8.13). Shrine uploads still need
# image processing; prefer libvips when present, else MiniMagick/ImageMagick.
module Babili
  module ImageProcessing
    module_function

    def backend
      @backend ||= begin
        ensure_vips!
        ::ImageProcessing::Vips
      rescue LoadError
        require "image_processing/mini_magick"
        ::ImageProcessing::MiniMagick
      end
    end

    def ensure_vips!
      return if defined?(::Vips)

      spec = Gem::Specification.find_by_name("ruby-vips")
      lib = File.join(spec.full_gem_path, "lib")
      $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
      require "vips"
      require "image_processing/vips"
    end
  end
end
