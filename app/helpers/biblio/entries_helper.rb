module Biblio::EntriesHelper
  def journal_for(article)
    "#{link_to(article.journal.name, article.journal)}#{' ' + article.volume if article.volume.present?}#{', ' if article.volume.present? && article.number.present?}#{'. ' if !article.volume.present? && article.number.present?}#{article.number}. #{article.pages + '.' if article.pages.present?}".html_safe
  end
end