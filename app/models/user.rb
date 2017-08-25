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
  has_one :profile

  before_create :build_profile

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
