# t.integer   :agent_id
# t.string    :language
# t.string    :period
# t.string    :trans

class Zensus::Appellation < ApplicationRecord
  belongs_to :agent, touch: true
  has_many :appellation_parts, -> { order(position: :asc) }

  accepts_nested_attributes_for :appellation_parts, reject_if: :all_blank, allow_destroy: true

  def name(options={})
    default = { reverse: false, prefix: false, suffix: false, preferred: true }
    (options.keys - default.keys).each{|key|
      puts "Undefined key #{key.inspect}"
    }
    options = default.merge(options)
    name = []
    appellation_parts.each do |n|
      if n.type == 'Prefix' && options[:prefix]
        name << n.body
      elsif n.type == 'Suffix' && options[:suffix]
        name << n.body
      elsif !n.type.in?(['Prefix', 'Suffix'])
        if options[:preferred]
          name << n.body if n.preferred?
        else
          name << n.body
        end
      end
    end
    options[:reverse] ? name.reverse.join(', ') : name.join(' ')
  end

  def self.transis
    %w[Transcription Transliteration]
  end

end

# Appellation
# E35 Title
# E42 Identifier
# E49 Time Appellation (Time-Span)
# E51 Contact Point
# P139 has alternative form: E41 Appellation
# (P139.1 has type: E55 Type)