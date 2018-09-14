#x t.string  :creator => Zensus::Activity
#? has_paper_trail on: :file_copyright
#? HasFileCopyrights through CopyrightEvents -> Zensus

module Raw
  class FileUpload < ApplicationRecord
    extend FriendlyId
    friendly_id :uuid, use: :slugged
    belongs_to :uploader, class_name: 'Person'
    belongs_to :publisher, class_name: 'Person', optional: true
    has_many :references, as: :referenceable, dependent: :destroy

    validates :type, :file, presence: true

    def self.types
      Image::TYPES + Audio::TYPES + Video::TYPES + Document::TYPES
    end

    def uuid
      uuid = loop do
        random_token = SecureRandom.uuid
        break random_token unless self.class.exists?(slug: random_token)
      end
      uuid
    end

    def self.descendants
      ObjectSpace.each_object(Class).select { |klass| klass < self }
    end

    # def file=(value)
    #   super
    #   self.type = set_type_from(file).try(:first)
    # end

    # def set_uploader
    #   raise self.inspect

    #   # attacher = klass.last.new(self, :file)
    #   # attacher.assign(value)
    #   #   if attacher.errors.any?
    #   #     raise ArgumentError.new(attacher.errors)
    #   #   else
    #   #     attacher.finalize unless attacher.stored?
    #   #   end
    # end

    # private
    #   def set_type_from(file)
    #     case file.mime_type
    #       when /^image\// then ['Raw::Image', Uploader::ImageUploader::Attacher]
    #       when /^audio\// then ['Raw::Audio', Uploader::AudioUploader::Attacher]
    #       when /^video\// then ['Raw::Video', Uploader::VideoUploader::Attacher]
    #       when "application/pdf" then ['Raw::Document', Uploader::DocumentUploader::Attacher]
    #       else nil
    #     end
    #   end
  
  end
end
