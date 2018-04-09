module Biblio::StylesHelper
  def apa(obj)
    if obj.type == 'Biblio::Serie'
      serie = obj
      ref = link_to serie.title, serie
    elsif obj.type == 'Biblio::Journal'
      journal = obj
      ref = link_to journal.name, journal
    elsif obj.type == 'Biblio::Article'
      article = obj
      ref = article.authors_list + ' '
      ref += article.year + '. ' 
      ref += link_to(article.punctioned_title, article) + ' '
      ref += content_tag :span, link_to(article.journal.name, article.journal ) + (article.volume.present? ? ' ' : '. '), class: 'journal-name'
      ref += content_tag :span, article.volume + ', ', class: 'journal-volume' if article.volume.present?
      ref += article.number + ', ' if article.number.present?
      ref += article.pages + '. ' if article.pages.present?
      ref += article.doi.present? ? article.doi : (article.url.present? ? article.url : '') if article.doi || article.url
    elsif obj.type == 'Biblio::Book'
      book = obj
      ref = book.authors_list + ' '
      ref += book.year + '. ' 
      ref += content_tag :span, link_to(book.punctioned_title, book) + ' ', class: 'book-title'
      ref += content_tag :span, "#{link_to(apa(book.serie), book.serie )}#{book.volume.present? ? ' ' : '. '}".html_safe, class: 'serie-title' if book.serie.present?
      ref += content_tag :span, book.volume + '. ', class: 'serie-volume' if book.volume.present?
      ref += book.publisher.default_name + (book.places.present? ? ': ' : '. ')
      ref += book.places.map(&:default_name).join('; ') + '. '
      ref += book.doi.present? ? book.doi : (book.url.present? ? book.url : '') if book.doi || book.url
    elsif obj.type == 'Biblio::Collection'
      coll = obj
      ref = coll.editors_list + ' '
      ref += coll.year + '. ' 
      ref += content_tag :span, link_to(coll.punctioned_title, coll) + ' ', class: 'collection-title'
      ref += content_tag :span, "#{link_to(serie_apa(coll.serie), coll.serie )}#{coll.volume.present? ? ' ' : '. '}".html_safe, class: 'serie-title' if coll.serie.present?
      ref += content_tag :span, coll.volume + '. ', class: 'serie-volume' if coll.volume.present?
      ref += coll.publisher.default_name + (coll.places.present? ? ': ' : '. ')
      ref += coll.places.map(&:default_name).join('; ') + '. ' if coll.places.present?
      ref += coll.doi.present? ? coll.doi : (coll.url.present? ? coll.url : '') if coll.doi || coll.url
    end
    ref.html_safe
  end

  def in_collection_apa(in_coll)
    ref = in_coll.authors.map{|a| a.name(reverse: true)}.join(', ') + ' '
    ref += in_coll.year + '. ' 
    ref += link_to(in_coll.punctioned_title, in_coll) + ' '
    ref += content_tag :span, "In: #{apa(in_coll.collection)}".html_safe, class: ''
    ref += in_coll.pages + '. ' if in_coll.pages.present?
    ref += in_coll.doi.present? ? in_coll.doi : (in_coll.url.present? ? in_coll.url : '') if in_coll.doi || in_coll.url
    ref.html_safe
  end
end