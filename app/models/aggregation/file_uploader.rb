class Aggregation::FileUploader < Shrine
  plugin :determine_mime_type
  plugin :instrumentation
  plugin :remove_attachment
  plugin :validation_helpers

  Shrine.logger = Rails.logger

  Attacher.validate do
    validate_max_size 10.megabytes, message: 'is too large (max is 10 MB)'
    #validate_mime_type_inclusion ['image/jpg', 'image/jpeg', 'image/png', 'image/gif']
  end
end
