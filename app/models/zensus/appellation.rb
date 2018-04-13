# t.integer   :agent_id
# t.string    :language
# t.string    :period
# t.string    :trans

class Zensus::Appellation < ApplicationRecord
  searchkick

  attr_accessor :new_agent_type, :creator
  def has_new_agent?
    self.new_agent_type.in?(Zensus::Agent.types)
  end

  belongs_to :agent, touch: true, optional: true
  has_many :appellation_parts, -> { order(position: :asc) }

  after_create :add_agent, if: :has_new_agent?

  accepts_nested_attributes_for :appellation_parts, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :agent, reject_if: :all_blank, allow_destroy: false

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

  def search_data
    {
      name: name(prefix: true, suffix: true, preferred: false),
      agent: (agent.default_name if agent)
    }
  end

  def self.sorted_by(sort_option)
    direction = ((sort_option =~ /desc$/) ? 'desc' : 'asc').to_sym
    case sort_option.to_s
    when /^updated_at_/
      { updated_at: direction }
    else
      raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  end

  def self.options_for_sorted_by
    [
      ['Updated asc', 'updated_at_asc'],
      ['Updated desc', 'updated_at_desc']
    ]
  end

  def add_agent
    agent = Zensus::Agent.new(creator: self.creator, type: "Zensus::#{self.new_agent_type}")
    agent.appellations << self
    agent.save
  end

end

# Appellation
# E35 Title
# E42 Identifier
# E49 Time Appellation (Time-Span)
# E51 Contact Point
# P139 has alternative form: E41 Appellation
# (P139.1 has type: E55 Type)