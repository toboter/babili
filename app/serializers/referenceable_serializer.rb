# Used by Discussion::Comment.mentions

class ReferenceableSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::TextHelper
  type :referenceables

  attribute :gid do
    object.to_global_id.uri
  end

  attribute :name do
    object.name
  end

  attribute :parents do
    case object.class.name
    when /^Vocab::\D*$/ then object.broader_concepts.map(&:name).join(', ')
    when /^Biblio::\D*$/ then object.parent.try(:name) ? "#{'in: ' + object.parent.try(:name)}" : ''
    when /^Writer::\D*$/ then object.repository.name_tree.join(' / ')
    when /^Discussion::\D*$/ then object.discussable.name_tree.join(' / ')
    end
  end

  attribute :note do
    case object.class.name
    when /^Vocab::\D*$/ then object.notes.try(:first).try(:body)
    when /^Biblio::\D*$/ then "#{object.title if object.try(:title)}"
    when /^Writer::\D*$/ then truncate(strip_tags(object.content), length: 100)
    when /^Discussion::\D*$/ then pluralize(object.comments_count, 'comment')
    end
  end

  attribute :labels do
    object.labels.map(&:body).join(', ') if object.class.name == 'Vocab::Concept'
  end

end
