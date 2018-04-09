class Biblio::Entry < ApplicationRecord
  include ActionView::Helpers::TextHelper
  has_closure_tree dependent: :destroy
  acts_as_taggable

  belongs_to :creator, class_name: 'Person'

  def self.types
    [
      'Biblio::Article',
      'Biblio::Book',
      'Biblio::Booklet',
      'Biblio::Collection',
      'Biblio::InBook',
      'Biblio::InCollection',
      'Biblio::InProceeding',
      'Biblio::Journal',
      'Biblio::Manual',
      'Biblio::Masterthesis',
      'Biblio::Misc',
      'Biblio::Phdthesis',
      'Biblio::Proceeding',
      'Biblio::Serie',
      'Biblio::Techreport',
      'Biblio::Unpublished'
    ]
  end

  def punctioned_title
    title.end_with?('.', '?')? title : title.concat('.') if title
  end

  def authors_list(limit=nil, reverse=true)
    authors.limit(limit).map{ |a| a.name(reverse: reverse) }.join(', ') + ' '
  end

  def editors_list(limit=nil, reverse=true)
    editors.limit(limit).map{ |a| a.name(reverse: reverse) }.join(', ') + " (#{'Ed'.pluralize(editors.count)}.) "
  end

  def citation
    if self.respond_to?(:authors)
      if authors.any?
        (authors.count > 3 ? authors_list(3).concat(' et al.') : authors_list).concat(self.respond_to?(:year) ? year : '')
      else
        key
      end
    elsif self.respond_to?(:editors)
      if editors.any?
        (editors.count > 3 ? editors_list(3).concat(' et al.') : editors_list).concat(self.respond_to?(:year) ? year : '')
      else
        key
      end
    end
  end
end