class Aggregation::Event::FileUpload < Aggregation::Event
  include FileUploader[:file]
  include Processable
  require 'roo'

  SCHEMA_TYPES = %w(Lido Tabular)

  jsonb_accessor :origin,
    file_data: :text,
    content_type: :string,
    schema: :string

  jsonb_accessor :processor,
    primary_id_label: :string,
    other_identificator_labels: :string


  after_create :process

  def process
    case (file.data['metadata']['filename']).split('.').last
      when ["csv", "ods", "xlsx"] then Aggregation::Commit::ProcessTabularJob.perform_later(self.id)
      when "xml" then self.parse_xml_file #Aggregation::Commit::ProcessXmlJob.perform_later(self.id)
      else raise "Unknown file type: #{file.data['metadata']['filename']}"
    end
  end

  def open_spreadsheet
    case (file.data['metadata']['filename']).split('.').last
    when "csv" then Roo::Csv.new(file.download.path)
    when "ods" then Roo::OpenOffice.new(file.download.path)
    when "xlsx" then Roo::Excelx.new(file.download.path)
    else raise "Unknown file type: #{file.data['metadata']['filename']}"
    end
  end
end