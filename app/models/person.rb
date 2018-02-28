class Person < ApplicationRecord
  include ImageUploader[:image]
  extend FriendlyId
  friendly_id :name, use: :slugged ### diser slug muss on create gesetzt werden. sonst gibt es keine person_page

  has_one :user
  has_many :blog_pages, class_name: 'CMS::BlogPage', foreign_key: :author_id
  has_many :memberships, dependent: :destroy
  has_many :organizations, through: :memberships
  has_many :person_oauth_accessibilities, as: :accessor, dependent: :destroy, class_name: 'OauthAccessibility'
  has_many :person_accessible_oauth_apps, through: :person_oauth_accessibilities, source: :oauth_application
  has_many :organization_accessible_oauth_apps, -> { distinct }, through: :organizations, source: :accessible_oauth_apps
  has_many :organization_oauth_accessibilities, -> { distinct }, through: :organizations, source: :oauth_accessibilities

  validates :user, presence: true

  delegate :username, :is_admin?, :oread_enrolled_applications, :email, to: :user

  def is?(person)
    self == person
  end

  def name
    [honorific_prefix, given_name, family_name, honorific_suffix].join(' ').strip.presence || username
  end

  def should_generate_new_friendly_id?
    changed?
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


end
