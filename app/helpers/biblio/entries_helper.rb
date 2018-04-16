module Biblio::EntriesHelper
  def journal_for(article)
    "#{link_to(article.journal.name, article.journal)}#{' ' + article.volume if article.volume.present?}#{', ' if article.volume.present? && article.number.present?}#{'. ' if !article.volume.present? && article.number.present?}#{article.number}. #{article.pages + '.' if article.pages.present?}".html_safe
  end

  def serie_for(book)
    "#{link_to(book.serie.title, book.serie)}#{' ' + book.volume if book.volume.present?}.".html_safe
  end

  def book_for(article)
    link_to format_citation(article.parent), article.parent
  end
end