# Eine Thread in einer Discussion kann sich polymorphisch als discussable auf ein Repo, Biblio::Entry, 
# Vocab::Scheme oder CMS::Content beziehen.
# It has participants: The author of the thread and anyone who makes a comment or is assigned.
# It has assignees who are responsible for moderation and to solve the problem.
# It has states. The last state gives the current state of the thread.
# It has many comments with any of them having a last version which is displayed.
# It has many titles. Thread.titles.last gives the current one.


# discussable_id:integer
# discussable_type:string
# author_id:integer
# state:string
# sequential_id:integer (-> bezieht sich auf sequence über scope discussable)
# comments_count:integer

module Discussion
  class Thread < ApplicationRecord
    acts_as_sequenced scope: [:discussable_id, :discussable_type]
    searchkick

    belongs_to :discussable, polymorphic: true
    belongs_to :author, class_name: 'Person'
    has_many :assignments, dependent: :destroy
    has_many :assignees, through: :assignments
    has_many :comments, dependent: :destroy
    has_many :mentionees, through: :comments
    has_many :states, dependent: :destroy
    has_many :titles, dependent: :destroy

    attr_accessor :title
    accepts_nested_attributes_for :comments, allow_destroy: false
    before_create -> { open_thread!(author) }

    validates :titles, presence: true

    scope :opend , ->{ where(state: 'open') }
    scope :closed , ->{ where(state: 'closed') }
    
    def to_param
      self.sequential_id.to_s
    end

    def current_state
      case state
        when 'open' then ['open', 'exclamation']
        when 'closed' then ['closed', 'check']
        when 'locked' then ['locked', 'lock']
        else []
      end
    end

    def title
      titles.last.try(:content)
    end

    def locked?
      current_state.first == 'locked'
    end

    def items
      items = []
      items << comments
      items << states.order(created_at: :asc).to_a.drop(1)
      items << titles.order(created_at: :asc).to_a.drop(1)
      items << comments.map{ |c| c.references.map{|r| r unless r.referenceable_type.in?(%w[Raw::FileUpload])}.compact }

      items.flatten.uniq
    end

    def moderators # gives an array of people who are allowed to do changes on the thread object
      mods = []
      mods << author
      mods << assignees.map(&:accessors)
      if discussable_type == 'Repository'
        if discussable.owner.subclass.class.name == 'Person'
          mods << discussable.owner.accessors
        elsif discussable.owner.subclass.class.name == 'Organization'
          mods << discussable.owner.subclass.memberships.where(role: 'Admin').map(&:person)
        end
      elsif discussable.class.base_class.name == 'Biblio::Entry'
        mods << discussable.creator
      end

      mods.flatten.uniq
    end

    def participants
      part = []
      part << author
      part << comments.map(&:author)

      part.flatten.uniq
    end

    def open_thread!(setter)
      self.states.build(content: 'open', setter: setter)
      self.state = 'open'
    end

    def close_thread!(setter)
      self.states.build(content: 'close', setter: setter)
      self.state = 'closed'
    end

    def lock_thread!(setter)
      self.states.build(content: 'lock', setter: setter)
      self.state = 'locked'
    end

    def unlock_thread!(setter)
      self.states.build(content: 'unlock', setter: setter)
      self.state = 'open'
    end

    def search_data
      {
        created_at: created_at,
        updated_at: updated_at,
        comments: comments_count,
        discussable_type: discussable_type,
        discussable_id: discussable_id,
        title: title,
        author: [author.name, author.namespace.name],
        is: [state],
        body: comments.map{ |c| ActionController::Base.helpers.strip_tags(c.current_body) }.join(' '),
        assignee: assignees.map(&:accessors).flatten.uniq.map{ |a| [a.name, a.namespace.name] }.concat(assignees.map{ |a| [a.subclass.name, a.name] }).uniq,
        mentions: mentionees.map(&:accessors).flatten.uniq.map{ |a| [a.name, a.namespace.name] }.concat(mentionees.map{ |a| [a.subclass.name, a.name] }).uniq
      }
    end

    def self.sorted_by(sort_option)
      direction = ((sort_option =~ /desc$/) ? 'desc' : 'asc').to_sym
      case sort_option.to_s
      when /^created_/
        { created_at: direction }
      when /^comments_/
        { comments: direction }
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
        ['Most commented', 'comments_desc'],
        ['Least commented', 'comments_asc'],
        ['Recently updated', 'updated_desc'],
        ['Least recently updated', 'updated_asc']
      ]
    end

  end
end