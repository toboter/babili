class Aggregation::Event::UploadEvent < Aggregation::Event
  require "roo"
  include AttrJson::Record
  include AttrJson::Record::QueryScopes
  include LidoExtraction, SheetExtraction

  # Keep polymorphic routes on Aggregation::Event (resources :events), not STI leaf names.
  def self.model_name
    Aggregation::Event.model_name
  end

  SCHEMA_TYPES = %w[Lido Tabular]

  attr_json_config(default_container_attribute: :origin)
  attr_json :description, :string
  attr_json :content_type, :string
  attr_json :schema, :string

  attr_json :primary_id_label, :string, container_attribute: "processors"
  attr_json :other_identificator_labels, :string, container_attribute: "processors"

  has_many :uploads, class_name: "Aggregation::Upload", foreign_key: :event_id, dependent: :destroy
  accepts_nested_attributes_for :uploads, reject_if: :all_blank, allow_destroy: true

  # Returns number of commits created.
  def process
    raise "No files uploaded for this event." if uploads.none?

    total = 0
    uploads.each do |upload|
      filename = upload.file.data.dig("metadata", "filename").to_s
      extension = filename.split(".").last.to_s.downcase
      total +=
        case extension
        when "xlsx", "csv", "ods" then process_sheet(upload.file)
        when "xml" then process_xml(upload.file)
        else
          raise "Unsupported file type: #{filename.presence || 'unknown'} (use csv, xlsx, ods, or LIDO xml)."
        end
    end
    total
  end

  # Parse uploads and attach a new version only for +item+ (matched by primary id).
  def process_version_for!(item)
    raise "No files uploaded for this event." if uploads.none?

    self.primary_id_label = primary_id_label.to_s.strip.presence || item.identifier.origin_type
    save! if changed?

    total = 0
    uploads.each do |upload|
      filename = upload.file.data.dig("metadata", "filename").to_s
      extension = filename.split(".").last.to_s.downcase
      total +=
        case extension
        when "xlsx", "csv", "ods" then process_sheet_version(upload.file, item)
        when "xml"
          raise "LIDO versioning from the item page is not supported yet. Use Import data for LIDO files."
        else
          raise "Unsupported file type: #{filename.presence || 'unknown'} (use csv, xlsx, or ods)."
        end
    end
    total
  end

  def process_xml(file)
    doc = Nokogiri::XML(file.read)
    json = JSON.parse(JSON.generate(doc.root))
    raise "XML is not a LIDO document." unless is_xml?(json, "lido-schema")

    commit_items(extract_lido(json, "lidoRecID"))
  end

  def process_sheet(file)
    commit_items(parse_sheet_rows(file))
  end

  def process_sheet_version(file, item)
    rows = parse_sheet_rows(file)
    target = item.identifier.origin_id.to_s
    matched = rows.select { |row| row.dig(:identifier, :value).to_s == target }
    if matched.empty?
      raise "No row found for primary key #{target.inspect} " \
            "(column #{primary_id_label.inspect})."
    end

    commit_version_for!(item, matched)
  end

  def parse_sheet_rows(file)
    downloaded = file.download
    path = downloaded.respond_to?(:path) ? downloaded.path : downloaded.to_s
    sheet = Roo::Spreadsheet.open(path)
    raise "Spreadsheet is empty." if sheet.last_row.to_i < 1

    raw_headers = sheet.row(1).map { |h| h.to_s.strip.presence }
    header_keys = raw_headers.map { |h| h.to_s.underscore.presence }
    raise "Spreadsheet header row is empty." if header_keys.compact.empty?
    raise "Spreadsheet has no data rows (need a header plus at least one data row)." if sheet.last_row.to_i < 2

    label = primary_id_label.to_s.strip.presence || header_keys.compact.first
    label = label.underscore
    unless header_keys.include?(label)
      raise "Primary key column #{label.inspect} not found in header #{header_keys.compact.inspect}."
    end

    self.primary_id_label = label if primary_id_label.blank? || primary_id_label.to_s.underscore != label
    save! if changed?

    rows = []
    (2..sheet.last_row).each do |i|
      values = sheet.row(i)
      next if values.compact.blank?

      paired = header_keys.zip(Array(values)).to_h.reject { |k, _| k.blank? }
      rows << extract_row(paired, label, columns: header_keys.compact)
    end

    raise "No usable data rows found in spreadsheet." if rows.empty?

    rows
  end
end
