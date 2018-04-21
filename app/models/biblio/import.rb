class Biblio::Import
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :file, :creator, :repository_ids, :bibtex_text
  
  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def persisted?
    false
  end

  def save
    if true #imported_entries.map(&:valid?).all?
      imported_entries.each(&:save!)
      true
    else
      imported_entries.each_with_index do |entry, index|
        entry.errors.full_messages.each do |message|
          errors.add :base, "Row #{index+2}: #{message}"
        end
      end
      false
    end
    #raise repository_ids.reject(&:blank?).map(&:to_i).inspect
  end

  def imported_entries
    @imported_entries ||= import_bibtex
  end

  def import_bibtex
    bib = file.present? ? BibTeX.open(file.path) : BibTeX.parse(bibtex_text)
    entries =[]
    bib['@book'].each do |book|
      entries << Biblio::Book.from_bib(book, creator)
    end
    bib['@collection'].each do |collection|
      entries << Biblio::Collection.from_bib(collection, creator)
    end
    bib['@article'].each do |article|
      entries << Biblio::Article.from_bib(article, creator)
    end
    bib['@incollection'].each do |in_collection|
      entries << Biblio::InCollection.from_bib(in_collection, creator, entries)
    end
    bib['@inbook'].each do |in_book|
      entries << Biblio::InCollection.from_bib(in_book, creator, entries)
    end


    entries
    # raise entries.inspect
  end

  def type(entry)
    Biblio::Entry.types.select {|t| t.include?('::'+entry.type.to_s.classify)}.first
  end

  def type_class(entry)
    type(entry).constantize
  end

  # nur mit type column
  def import_entries_from_spreadsheet
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