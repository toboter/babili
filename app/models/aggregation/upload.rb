# uploaded files
class Aggregation::Upload < ApplicationRecord
  include FileUploader[:file]
  belongs_to :upload_event, class_name: 'Aggregation::Event::UploadEvent', foreign_key: :event_id

end