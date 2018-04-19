module Biblio::StylesHelper

  def format_citation(obj, strip_list=true)
    if obj.type == 'Biblio::Serie'
      serie = obj
      ref = serie.title
    elsif obj.type == 'Biblio::Journal'
      journal = obj
      ref = journal.name
    else
      bib = BibTeX::Bibliography.new
      bib << obj.to_bib
      cp = CiteProc::Processor.new style: (current_user.try(:person).try(:csl).present? ? current_user.person.csl : 'apa'), format: 'html'
      cp.import bib.to_citeproc
      ref = cp.bibliography.join
      ref = ref.gsub(%r{<ol/?[^>]+?>}, '').gsub(%r{<li/?[^>]+?>}, '').gsub(/<\/ol>|<\/li>/, '') if strip_list
      ref.html_safe
    end

#flow
# a=Biblio::InBook.first.to_bib
# bib = BibTeX::Bibliography.new
# bib << a
# cp = CiteProc::Processor.new style: 'apa', format: 'text'
# cp.import bib.to_citeproc
# cp.bibliography.join


#    elsif obj.type == 'Biblio::Article'
#      article = obj
#      ref = article.authors_list + ' '
#      ref += article.year + '. ' 
#      ref += article.punctioned_title + ' '
#      ref += content_tag :span, article.journal.name + (article.volume.present? ? ' ' : '. '), class: 'journal-name'
#      ref += content_tag :span, article.volume + ', ', class: 'journal-volume' if article.volume.present?
#      ref += article.number + ', ' if article.number.present?
#      ref += article.pages + '. ' if article.pages.present?
#      ref += article.doi.present? ? article.doi : (article.url.present? ? article.url : '') if article.doi || article.url
#    elsif obj.type == 'Biblio::Book'
#      book = obj
#      ref = book.authors_list + ' '
#      ref += book.year + '. ' 
#      ref += content_tag :span, book.punctioned_title + ' ', class: 'book-title'
#      ref += content_tag :span, "#{apa(book.serie)}#{book.volume.present? ? ' ' : '. '}".html_safe, class: 'serie-title' if book.serie.present?
#      ref += content_tag :span, book.volume + '. ', class: 'serie-volume' if book.volume.present?
#      ref += book.publisher.default_name + (book.places.present? ? ': ' : '. ')
#      ref += book.places.map(&:default_name).join('; ') + '. '
#      ref += book.doi.present? ? book.doi : (book.url.present? ? book.url : '') if book.doi || book.url
#    elsif obj.type == 'Biblio::Collection'
#      coll = obj
#      ref = coll.editors_list + ' '
#      ref += coll.year + '. ' 
#      ref += content_tag :span, coll.punctioned_title + ' ', class: 'collection-title'
#      ref += content_tag :span, "#{serie_apa(coll.serie)}#{coll.volume.present? ? ' ' : '. '}".html_safe, class: 'serie-title' if coll.serie.present?
#      ref += content_tag :span, coll.volume + '. ', class: 'serie-volume' if coll.volume.present?
#      ref += coll.publisher.default_name + (coll.places.present? ? ': ' : '. ')
#      ref += coll.places.map(&:default_name).join('; ') + '. ' if coll.places.present?
#      ref += coll.doi.present? ? coll.doi : (coll.url.present? ? coll.url : '') if coll.doi || coll.url
#    elsif obj.type == 'Biblio::InCollection'
#      in_coll = obj
#      ref = in_coll.authors.map{|a| a.name(reverse: true)}.join(', ') + ' '
#      ref += in_coll.year + '. ' 
#      ref += in_coll.punctioned_title + ' '
#      ref += content_tag :span, "In: #{apa(in_coll.collection)}".html_safe, class: ''
#      ref += in_coll.pages + '. ' if in_coll.pages.present?
#      ref += in_coll.doi.present? ? in_coll.doi : (in_coll.url.present? ? in_coll.url : '') if in_coll.doi || in_coll.url
#    elsif obj.type == 'Biblio::Proceeding'
#      ref = ''
#    elsif obj.type == 'Biblio::InProceeding'
#      ref = ''
#    elsif obj.type == 'Biblio::Booklet'
#      ref = ''
#    elsif obj.type == 'Biblio::InBook'
#      ref = ''
#    elsif obj.type == 'Biblio::Manual'
#      ref = ''
#    elsif obj.type == 'Biblio::Masterthesis'
#      ref = ''
#    elsif obj.type == 'Biblio::Misc'
#      ref = ''
#    elsif obj.type == 'Biblio::Phdthesis'
#      ref = ''
#    elsif obj.type == 'Biblio::Techreport'
#      ref = ''
#    elsif obj.type == 'Biblio::Unpublished'
#      ref = ''
#    end
#    ref.html_safe
  end
end