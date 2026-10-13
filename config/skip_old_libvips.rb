# frozen_string_literal: true

# Rails 8 ActiveStorage aborts when ruby-vips loads against libvips < 8.13.
# Babili uploads use Shrine + ImageProcessing::MiniMagick only. Hide ruby-vips
# from the load path so ActiveStorage's Vips probe rescues LoadError and continues.
$LOAD_PATH.reject! { |p| p.include?("/ruby-vips-") }
