# Document
# t.integer   :repository_id
# t.string    :title
# t.text      :content
# t.integer   :char_count
# t.integer   :word_count
# t.string    :language
# t.integer   :sequential_id
# t.datetime  :published_at
# t.integer   :publisher_id
# t.integer   :creator_id
# t.jsonb     :settings
#x t.integer   :drafts_count
# t.timestamps


module Writer
  class Document < ApplicationRecord
    acts_as_sequenced scope: :repository_id
    has_paper_trail only: [:title, :content], versions: :drafts
    searchkick

    belongs_to :creator, class_name: 'Person'
    belongs_to :publisher, class_name: 'Person', optional: true
    belongs_to :repository
    has_many :references, as: :referencing, dependent: :destroy
    has_many :files, through: :references, source_type: 'Raw::FileUpload', source: :referenceable
    has_many :categorizations, dependent: :destroy
    has_many :categories, through: :categorizations, class_name: 'CategoryNode'

    validates :content, presence: true

    delegate :collaborators, to: :repository

    before_validation do
      striped_content = ActionView::Base.full_sanitizer.sanitize(content.gsub("<br>", ' ').gsub("<\p>", ' '))
      self.title = striped_content.truncate_words(5) if title.blank? && content.present?
      self.char_count = striped_content.length
      self.word_count = striped_content.scan(/[\w-]+/).size
    end
    before_validation :extract_attachments

    def to_param
      self.sequential_id.to_s
    end

    def published?
      published_at.present? && publisher.present?
    end

    def authors
      author_ids = drafts.map(&:whodunnit).compact.map(&:to_i).uniq
      Person.where(id: author_ids)
    end

    def extract_attachments
      doc = Nokogiri::HTML(content)
      references = []
      doc.css("[data-attachment]").each do |attachment_node|
        attachment = JSON.parse(attachment_node.attribute('data-attachment'))
        if attachment['type'] == 'File'
          references << attachment
        end
      end
      set_references(references)
    end

    def set_references(values)
      attached_referenceables = values.map{|v| GlobalID::Locator.locate(v['gid']) }.uniq
      references.where.not(referenceable: attached_referenceables).destroy_all
      attached_references = attached_referenceables.map{|r| Reference.new(referenceable: r, referencor_id: ::PaperTrail.request.whodunnit)}
      if attached_references.present?
        references << attached_references.map{|r| r unless r.referenceable.in?(references.map(&:referenceable).compact.flatten)}.compact
      end
    end


    def search_data
      {
        created_at: created_at,
        updated_at: updated_at,
        title: title,
        content: ActionView::Base.full_sanitizer.sanitize(content),
        repository: repository.name,
        repository_id: repository.id,
        author: authors.map{ |a| [a.name, a.namespace.name]},
      }
    end

    def self.sorted_by(sort_option)
      direction = ((sort_option =~ /desc$/) ? 'desc' : 'asc').to_sym
      case sort_option.to_s
      when /^title_/
        { title: direction }
      when /^created_/
        { created_at: direction }
      when /^updated_/
        { updated_at: direction }
      else
        raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
      end
    end
  
    def self.options_for_sorted_by
      [
        ['Newest', 'created_desc'],
        ['Oldest', 'created_asc'],
        ['Title A-Z', 'title_asc'],
        ['Title Z-A', 'title_desc'],
        ['Recently updated', 'updated_desc'],
        ['Least recently updated', 'updated_asc']
      ]
    end

  end
end