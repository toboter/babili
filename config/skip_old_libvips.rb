# frozen_string_literal: true

# Rails 8 ActiveStorage aborts when ruby-vips loads against libvips < 8.13.
# Hide ruby-vips during boot so ActiveStorage's Vips probe rescues LoadError and
# continues with MiniMagick (config.active_storage.variant_processor).
# Shrine uploads re-enable vips via Babili::ImageProcessing when needed.
$LOAD_PATH.reject! { |p| p.include?("/ruby-vips-") }
