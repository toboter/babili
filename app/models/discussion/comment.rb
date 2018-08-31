# A comment is a wrapper for multiple versions of a comment. It has the author as the only person 
# who is allowed to create new versions. It belongs to a thread.

# thread_id:integer
# author_id:integer
# versions_count:integer

module Discussion
  class Comment < ApplicationRecord
    belongs_to :thread, counter_cache: true, autosave: true, touch: true
    belongs_to :author, class_name: 'Person'
    has_many :versions, dependent: :destroy
    has_many :mentions, as: :mentionable, dependent: :destroy
    has_many :mentionees, through: :mentions
    has_many :references, as: :referencing, dependent: :destroy
    has_many :files, through: :references, source_type: 'Raw::FileUpload', source: :referenceable

    before_validation :extract_attachments
    after_commit :reindex_thread, on: [:update, :destroy]

    accepts_nested_attributes_for :versions, allow_destroy: false

    delegate :title, to: :thread

    def current_body # gives the last current version of the comment
      versions.last.try(:body)
    end

    def author_role # describes the role of the comments author for the given discussable object
      if thread.discussable.class.name == 'Repository'
        if thread.discussable.owner.subclass.class.name == 'Person'
          author.in?(thread.discussable.owner.accessors) ? 'Owner' : nil
        elsif thread.discussable.owner.subclass.class.name == 'Organization'
          thread.discussable.owner.subclass.memberships.where(person: author).try(:first).try(:role).presence || nil
        end
      elsif thread.discussable.class.base_class.name == 'Biblio::Entry'
        author == thread.discussable.creator ? 'Creator' : nil
      end
    end

    def extract_attachments
      doc = Nokogiri::HTML(current_body)
      mentions = []
      references = []
      doc.css("[data-trix-attachment]").each do |attachment_node|
        attachment = JSON.parse(attachment_node.attribute('data-trix-attachment'))
        if attachment['type'] == 'Mention'
          mentions << attachment
        elsif attachment['type'] == 'File' || attachment['type'] == 'Reference'
          references << attachment
        end
      end
      set_mentions(mentions)
      set_references(references)
      reindex_thread
    end

    def set_mentions(values)
      attached_mentionees = values.map{|v| GlobalID::Locator.locate(v['gid']) }.uniq
      mentions.where.not(mentionee: attached_mentionees).destroy_all
      attached_mentions = attached_mentionees.map{|m| Mention.new(mentionee: m, mentioner: author)}
      if attached_mentions.present?
        mentions << attached_mentions.map{|m| m unless m.mentionee.in?(mentionees) }.compact
      end
    end

    def set_references(values)
      attached_referenceables = values.map{|v| GlobalID::Locator.locate(v['gid']) }.uniq
      references.where.not(referenceable: attached_referenceables).destroy_all
      attached_references = attached_referenceables.map{|r| Reference.new(referenceable: r, referencor: author)}
      if attached_references.present?
        references << attached_references.map{|r| r unless r.referenceable.in?(references.map(&:referenceable).compact.flatten)}.compact
      end
    end

    def reindex_thread
      thread.reindex
    end
  
  end
end