class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, 
         authentication_keys: [:login]
  
  attr_accessor :login

  validates :username, presence: true, on: :create
  validates :username,
    uniqueness: {
      case_sensitive: false,
      allow_blank: true
    }
  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, multiline: true

  has_many :oauth_accessibilities, as: :accessor, dependent: :delete_all
  has_many :oauth_applications, through: :oauth_accessibilities
  has_many :oauth_application_ownerships, class_name: 'Doorkeeper::Application', as: :owner

  has_many :oread_access_tokens, class_name: 'Oread::AccessToken', foreign_key: 'resource_owner_id'
  has_many :oread_applications, through: :oread_access_tokens, source: :application
  has_many :oread_application_ownerships, class_name: 'Oread::Application', as: :owner

  has_many :memberships, dependent: :delete_all
  has_many :projects, through: :memberships
  has_many :project_oauth_applications, through: :projects, source: :oauth_applications
  has_many :project_oauth_accessibilities, through: :projects, source: :oauth_accessibilities
  has_one :profile

  before_create :build_profile

  def all_oauth_applications
    Doorkeeper::Application.joins(:accessibilities).where('oauth_accessibilities.id IN (?)', all_oauth_accessibilities.ids).order(id: :asc)
  end

  def all_oauth_accessibilities
    OauthAccessibility.where(accessor_id: self.id, accessor_type: self.class.name).or(OauthAccessibility.where(accessor_id: self.project_ids, accessor_type: 'Project')).distinct
  end

  def all_combined_oauth_accessibility_grants
    acc=[]
    for u_application in all_oauth_applications.distinct do
      obj = OauthAccessibility.new(oauth_application_id: u_application.id)
      u_application.accessibilities.where(id: all_oauth_accessibilities.ids).each do |a|
        obj.can_manage = true if a.can_manage == true
        obj.can_create = true if a.can_create == true
        obj.can_read = true if a.can_read == true
        obj.can_update = true if a.can_update == true
        obj.can_destroy = true if a.can_destroy == true
        obj.can_comment = true if a.can_comment == true
        obj.can_publish = true if a.can_publish == true
      end
      acc << obj
    end
    acc
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_hash).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_hash).first
    end
  end

  
  def name
    if profile && profile.display_name.present?
      profile.display_name
    else
      username.presence || email
    end
  end

  def accessible
    [id, self.class.name].join(",")
  end

end
