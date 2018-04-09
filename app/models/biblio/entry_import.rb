class Biblio::EntryImport
  require 'roo'
  # switch to ActiveModel::Model in Rails 4
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :file
  
  def self.col_attr
    %w(type title subtitle first_page last_page page_count volume published_date abbr edition language place publisher serie_name)
  end

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def persisted?
    false
  end

  def save
  # raise imported_subjects.first.creators.inspect
    if imported_subjects.map(&:valid?).all?
      imported_subjects.each(&:save!)
      true
    else
      imported_subjects.each_with_index do |subject, index|
        subject.errors.full_messages.each do |message|
          errors.add :base, "Row #{index+2}: #{message}"
        end
      end
      false
    end
  end

  def imported_subjects
    @imported_subjects ||= load_imported_subjects
  end

  def load_imported_subjects
    spreadsheet = open_spreadsheet
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).map do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      type = Biblio::Entry.types.include?(row["type"]) ? row["type"] : "Biblio::Entry"
      subject = Biblio::Entry.find_by_id(row["id"]) || type.constantize.new
      subject.attributes = row.to_hash.slice(*Biblio::EntryImport.col_attr)
      subject.creator_list = row["creator_list"].split(';').map{|r| r.strip} if row["creator_list"]
      subject.tag_list = row["tag_list"].split(',').map{|r| r.strip} if row["tag_list"]
      if type == 'InJournal' && row["serie_name"] && row["volume"] && row["published_date"]
        if row["serie_name"].include?('#')
          abbr = row["serie_name"].split('#').first.squish
          name = row["serie_name"].split('#').last.squish
          serie = Serie.where(abbr: abbr, name: name).first_or_create!
        end
        subject.parent = Biblio::Entry.where(type: 'Issue', serie: serie, volume: row["volume"], published_date: row["published_date"]).first_or_create!
      elsif row["parent"] && Biblio::Entry.child_types.include?(row["type"])
        subject.parent = Biblio::Entry.find_by_cite(row["parent"])
      end
      subject
    end
  end

  def open_spreadsheet
    case File.extname(file.original_filename)
    when ".csv" then Roo::Csv.new(file.path)
    when ".ods" then Roo::OpenOffice.new(file.path)
    when ".xlsx" then Roo::Excelx.new(file.path)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end
end