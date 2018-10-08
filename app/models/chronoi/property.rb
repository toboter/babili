module Chronoi
  class Property < ApplicationRecord
      # t.integer    :entity_id
      # t.string     :type
      # self.inheritance_column = :_type_disabled
      # t.references :rangeable
      # t.text       :note

      belongs_to :rangeable, polymorphic: true
      belongs_to :entity, optional: true

      # after_commit :reindex_entity_and_range, on: [:create, :update]

      def name(options={})
        default = { inverse: false }
        (options.keys - default.keys).each{|key|
          puts "Undefined key #{key.inspect}"
        }
        options = default.merge(options)
        options[:inverse] ? self.class.const_get(:INVERSE_NAME) : self.class.name.demodulize.titleize.downcase
      end

      def title
        "#{name(inverse: true)} (#{entity.type}) on #{entity.default_date}"
      end

      def description
        "#{range.default_name} #{name(inverse: true)} #{[entity.properties-[self]].flatten.map{|a| [a.name, a.range.default_name].join(' ') }.join(', ')}#{' on ' + entity.default_date if entity.begins_at.present?}"
      end

      def range_gid
        range.try(:to_global_id)
      end

      def range_gid=(gid)
        self.range = GlobalID::Locator.locate gid
      end


      def reindex_entity_and_range
        entity.reindex
        range.reindex
      end
  end
end