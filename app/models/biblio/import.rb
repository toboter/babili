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
    repositories = Repository.find(repository_ids.reject(&:blank?).map(&:to_i))

    if imported_entries.map(&:valid?).all?
      imported_entries.each(&:save!)
      entries = imported_entries.map{|i| i.self_and_ancestors }.flatten.uniq
      repositories.each do |repo|
        repo.references << entries.map{|e| e unless e.repositories.include?(repo)}.compact # so haben die keinen creator! erscheint mir aber eben einfacher.
      end
      true
    else
      imported_entries.each_with_index do |entry, index|
        entry.errors.full_messages.each do |message|
          errors.add :base, "Row #{index+2}: #{message}"
        end
      end
      false
    end
  end

  def imported_entries
    @imported_entries ||= import_bibtex
  end

  def import_bibtex
    bib = file.present? ? BibTeX.open(file.path).convert(:latex) : BibTeX.parse(bibtex_text).convert(:latex)
    #raise bib.data.first.type.inspect
    entries =[]
    bib['@book'].each do |book|
      entries << Biblio::Book.from_bib(book, creator)
    end
    bib['@booklet'].each do |book|
      entries << Biblio::Booklet.from_bib(book, creator)
    end
    bib['@manual'].each do |book|
      entries << Biblio::Manual.from_bib(book, creator)
    end
    bib['@collection'].each do |collection|
      entries << Biblio::Collection.from_bib(collection, creator)
    end
    bib['@proceeding'].each do |proceeding|
      entries << Biblio::Proceeding.from_bib(proceeding, creator)
    end
    bib['@article'].each do |article|
      entries << Biblio::Article.from_bib(article, creator)
    end
    bib['@incollection'].each do |in_collection|
      entries << Biblio::InCollection.from_bib(in_collection, creator, entries)
    end
    bib['@conference'].each do |conference|
      entries << Biblio::InCollection.from_bib(conference, creator, entries)
    end
    bib['@inbook'].each do |in_book|
      entries << Biblio::InBook.from_bib(in_book, creator, entries)
    end
    bib['@inproceeding'].each do |in_proceeding|
      entries << Biblio::InProceeding.from_bib(in_proceeding, creator, entries)
    end
    bib['@mastersthesis'].each do |mastersthesis|
      entries << Biblio::Masterthesis.from_bib(mastersthesis, creator)
    end
    bib['@phdthesis'].each do |phdthesis|
      entries << Biblio::Phdthesis.from_bib(phdthesis, creator)
    end
    bib['@misc'].each do |misc|
      entries << Biblio::Misc.from_bib(misc, creator)
    end
    bib['@techreport'].each do |techreport|
      entries << Biblio::Techreport.from_bib(techreport, creator)
    end
    bib['@unpublished'].each do |unpublished|
      entries << Biblio::Unpublished.from_bib(unpublished, creator)
    end
    entries
    # raise entries.inspect
  end


end