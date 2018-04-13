class Biblio::Entry < ApplicationRecord
  extend FriendlyId
  friendly_id :citation, use: :slugged
  searchkick inheritance: true
  include ActionView::Helpers::TextHelper
  has_closure_tree dependent: :destroy
  acts_as_taggable

  belongs_to :creator, class_name: 'Person'
  has_many :referencations, class_name: 'Biblio::Referencation', dependent: :destroy
  has_many :repositories, through: :referencations

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

  def should_generate_new_friendly_id?
    true || super
  end

  def punctioned_title
    title.end_with?('.', '?')? title : title.concat('.') if title
  end

  def authors_list(limit=nil, reverse=true)
    authors.limit(limit).map{ |a| a.name(reverse: reverse) }.join(', ') + ' '
  end

  def editors_list(limit=nil, reverse=true)
    editors.limit(limit).map{ |a| a.name(reverse: true) }.join(', ') + " (#{'Ed'.pluralize(editors.count)}.) "
  end


  def citation_authors_list
    authors.take(3).map{ |a| a.name(reverse: true).split(', ').first }.join(', ') + ' '
  end

  def citation_editors_list
    editors.take(3).map{ |a| a.name(reverse: true).split(', ').first }.join(', ') + " (#{'Ed'.pluralize(editors.count)}.) "
  end

  def citation
    if self.respond_to?(:authors)
      if authors.any?
        (authors.count > 3 ? citation_authors_list.concat(' et al. ') : citation_authors_list).concat(self.respond_to?(:year) ? (year.present? ? year : '') : '')
      else
        key
      end
    elsif self.respond_to?(:editors)
      if editors.any?
        (editors.count > 3 ? citation_editors_list.concat(' et al. ') : citation_editors_list).concat(self.respond_to?(:year) ? (year.present? ? year : '') : '')
      else
        key
      end
    else
      name
    end
  end
end