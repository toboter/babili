# t.integer   :agent_id
# t.string    :language
# t.string    :period
# t.string    :trans

class Zensus::Appellation < ApplicationRecord
  searchkick

  belongs_to :agent, touch: true, optional: true, inverse_of: :appellations
  has_many :appellation_parts, -> { order(position: :asc) }
  has_many :creatorships, dependent: :destroy, class_name: 'Biblio::Creatorship', foreign_key: :agent_appellation_id
  has_many :creations, -> { order 'biblio_creatorships.id asc' }, through: :creatorships, source: :entry, class_name: 'Biblio::Entry'

  after_save :set_agent_activities_from_self

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
      if n.type.in?(['Appellation', 'Title']) && options[:prefix]
        name << n.body
      elsif n.type == 'Suffix' && options[:suffix]
        name << n.body
      elsif !n.type.in?(['Appellation', 'Title', 'Suffix', 'Nick'])
        if options[:preferred]
          name << n.body if n.preferred?
        else
          name << n.body
        end
      end
    end
    options[:reverse] ? name.reverse.join(', ') : name.join(' ')
  end

  def name=(full_name)
    name_parts = Namae.parse(full_name).first
    self.appellation_parts.build(body: name_parts.given, type: 'Given', preferred: true) if name_parts.given
    self.appellation_parts.build(body: name_parts.family, type: 'Family', preferred: true) if name_parts.family.present?
    self.appellation_parts.build(body: name_parts.nick, type: 'Nick') if name_parts.nick
    self.appellation_parts.build(body: name_parts.particle, type: 'Particle') if name_parts.particle
    self.appellation_parts.build(body: name_parts.appellation, type: 'Appellation') if name_parts.appellation
    self.appellation_parts.build(body: name_parts.title, type: 'Title') if name_parts.title
    self.appellation_parts.build(body: name_parts.suffix, type: 'Suffix') if name_parts.suffix
  end

  def self.find_by_name(full_name)
    name = Namae.parse(full_name).first
    appellations = all.joins(:appellation_parts)
    appellations = appellations.merge(Zensus::AppellationPart.identify(name.family, 'Family')) if name.family
    appellations = appellations.merge(Zensus::AppellationPart.identify(name.given, 'Given')) if name.given
    appellations = appellations.merge(Zensus::AppellationPart.identify(name.title, 'Title')) if name.title
    appellations = appellations.merge(Zensus::AppellationPart.identify(name.nick, 'Nick')) if name.nick
    appellations = appellations.merge(Zensus::AppellationPart.identify(name.appellation, 'Appellation')) if name.appellation
    appellations = appellations.merge(Zensus::AppellationPart.identify(name.suffix, 'Suffix')) if name.suffix
    appellations = appellations.merge(Zensus::AppellationPart.identify(name.particle, 'Particle')) if name.particle
    return appellations
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

  def set_agent_activities_from_self

  end

end

# Appellation
# E35 Title
# E42 Identifier
# E49 Time Appellation (Time-Span)
# E51 Contact Point
# P139 has alternative form: E41 Appellation
# (P139.1 has type: E55 Type)