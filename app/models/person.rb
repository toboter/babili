class Person < ApplicationRecord
  include ImageUploader[:image]
  acts_as_tagger
  include AttrJson::Record
  include AttrJson::Record::QueryScopes
  attr_json_config(default_container_attribute: :settings)

  attr_json :csl, :string, default: 'apa'
  attr_json :per_page, :integer, default: 50

  has_one :namespace, as: :subclass, dependent: :destroy
  has_one :user
  has_many :collaborations, dependent: :destroy, foreign_key: :collaborator_id
  has_many :collaboration_repos, through: :collaborations, source: :collaboratable, source_type: 'Repository'
  has_many :blog_pages, class_name: 'CMS::BlogPage', foreign_key: :author_id
  has_many :memberships, dependent: :destroy
  has_many :organizations, through: :memberships
  has_many :person_oauth_accessibilities, as: :accessor, dependent: :destroy, class_name: 'OauthAccessibility'
  has_many :person_accessible_oauth_apps, through: :person_oauth_accessibilities, source: :oauth_application
  has_many :organization_accessible_oauth_apps, -> { distinct }, through: :organizations, source: :accessible_oauth_apps
  has_many :organization_oauth_accessibilities, -> { distinct }, through: :organizations, source: :oauth_accessibilities

  validates :namespace, presence: true

  delegate :repositories, to: :namespace

  scope :approved, -> { joins(:user).where(users: {approved: true}) }

  #after_commit :reindex_namespace
  
  def to_param
    namespace.slug if namespace
  end

  def self.find(input)
    input.to_i == 0 ? Namespace.friendly.find(input).subclass : super
  end

  def oread_enrolled_applications # deprecated
    user ? user.oread_enrolled_applications : []
  end

  def email
    user ? user.email : false
  end

  def is?(person)
    self == person
  end

  def is_admin?
    user ? user.is_admin? : false
  end

  def name
    [honorific_prefix, given_name, family_name, honorific_suffix].join(' ').strip.presence || namespace.slug
  end

  def all_repos
    repos = []
    repositories.to_a.concat(organizations.map(&:repositories).to_a).concat(collaboration_repos.to_a).flatten
  end


  def oauth_accessibilities
    accessibilities = person_oauth_accessibility_ids.concat(organization_oauth_accessibility_ids).uniq
    OauthAccessibility.where(id: accessibilities)
  end

  def oauth_applications
    Doorkeeper::Application.joins(:accessibilities).where('oauth_accessibilities.id IN (?)', oauth_accessibilities.ids).order(id: :asc).uniq
  end

  def oauth_grants_for(application)
    application.grants(self)
  end

  def oauth_grants
    grants=[]
    oauth_applications.each do |application|
      grants << application.grants(self)
    end
    grants.flatten
  end

  def reindex_namespace
    namespace.reindex
  end

end
