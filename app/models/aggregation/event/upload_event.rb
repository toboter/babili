
class Aggregation::Event::UploadEvent < Aggregation::Event
  require 'roo'
  include AttrJson::Record
  include AttrJson::Record::QueryScopes
  include LidoExtraction, SheetExtraction

  SCHEMA_TYPES = %w(Lido Tabular)

  attr_json_config(default_container_attribute: :origin)
  attr_json :description, :string
  attr_json :content_type, :string
  attr_json :schema, :string

  attr_json :primary_id_label, :string, container_attribute: "processors"
  attr_json :other_identificator_labels, :string, container_attribute: "processors"

  has_many :uploads, class_name: 'Aggregation::Upload', foreign_key: :event_id, dependent: :destroy
  accepts_nested_attributes_for :uploads, reject_if: :all_blank, allow_destroy: true

  def pre_process
    # was wurde hochgeladen? xml oder "csv", "ods", "xlsx"? wieviele Dateien, unterscheiden sie sich im typ?
  end

  def process
    uploads.each do |u|
      case (u.file.data['metadata']['filename']).split('.').last
        when "xlsx" then self.process_sheet(u.file)
        when "csv" then self.process_sheet(u.file)
        when "ods" then self.process_sheet(u.file)
        when "xml" then self.process_xml(u.file)
        else raise "Unknown file type: #{u.file.data['metadata']['filename']}"
      end
    end
    return true # sollte es irgendwann mal
  end

  def process_xml(file)
    doc = Nokogiri::XML(file.read)
    json = JSON.parse(JSON.generate(doc.root))
    if is_xml?(json, 'lido-schema')
      json = extract_lido(json, 'lidoRecID')
      commit_items(json)
    end
  end

  def process_sheet(file)
    sheet = Roo::Spreadsheet.open(file.download.path)
    header = sheet.row(1).map{|h| h.underscore }
    json = []
    (2..sheet.last_row).each do |i|
      json << extract_row(Hash[[header, sheet.row(i)].transpose], processors['primary_id_label'])
    end
    commit_items(json)
  end
end