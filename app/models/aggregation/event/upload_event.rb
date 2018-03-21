class Aggregation::Event::UploadEvent < Aggregation::Event
  require 'roo'
  include LidoExtraction, SheetExtraction

  SCHEMA_TYPES = %w(Lido Tabular)

  has_many :uploads, class_name: 'Aggregation::Upload', foreign_key: :event_id, dependent: :destroy
  accepts_nested_attributes_for :uploads, reject_if: :all_blank, allow_destroy: true

  jsonb_accessor :origin,
    description: :text,
    content_type: :string,
    schema: :string

  jsonb_accessor :processor,
    primary_id_label: :string,
    other_identificator_labels: :string

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
      commit_items('Aggregation::Item::ExcavatedResource', json)
    end
  end

  def process_sheet(file)
    sheet = Roo::Spreadsheet.open(file.download.path)
    header = sheet.row(1).map{|h| h.underscore }
    json = []
    (2..sheet.last_row).each do |i|
      json << extract_row(Hash[[header, sheet.row(i)].transpose], 'bab_rel')
    end
    commit_items('Aggregation::Item::ExcavatedResource', json)
  end
end