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
    has_many :mentions, as: :mentionable
    has_many :references, as: :referencing, dependent: :destroy
    has_many :files, through: :references, source_type: 'Raw::FileUpload', source: :referenceable

    before_validation :extract_references

    accepts_nested_attributes_for :versions, allow_destroy: false

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

    def extract_references
      # das gilt für references vom type Raw::*
      # gilt nicht für Person als Mention
      doc = Nokogiri::HTML(current_body)
      attachments = []
      doc.css("[data-trix-attachment]").each do |attachment_node|
        attachment = JSON.parse(attachment_node.attribute('data-trix-attachment'))
        attachments << Reference.new(referenceable: attachment['type'].classify.constantize.friendly.find(attachment['id']), referencor: author)
      end
      references.destroy(references.map{|r| r unless r.in?(attachments)})
      references << attachments.map{|a| a unless a.in?(references)}
    end
  
  end
end