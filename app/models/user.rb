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

  has_many :oauth_accessibilities, as: :accessor, dependent: :destroy
  has_many :oauth_applications, through: :oauth_accessibilities
  has_many :oauth_application_ownerships, class_name: 'Doorkeeper::Application', as: :owner

  has_many :oread_access_tokens, class_name: 'Oread::AccessToken', foreign_key: 'resource_owner_id', dependent: :destroy
  has_many :oread_access_enrollments, class_name: 'Oread::AccessEnrollment', foreign_key: 'enrollee_id', dependent: :destroy

  has_many :oread_token_applications, through: :oread_access_tokens, source: :application
  has_many :oread_enrolled_applications, through: :oread_access_enrollments, source: :application

  has_many :oread_application_ownerships, class_name: 'Oread::Application', as: :owner

  has_many :personal_access_tokens, foreign_key: :resource_owner_id

  has_many :memberships, dependent: :destroy
  has_many :projects, through: :memberships
  has_many :project_oauth_applications, through: :projects, source: :oauth_applications
  has_many :project_oauth_accessibilities, through: :projects, source: :oauth_accessibilities
  has_one :profile, dependent: :destroy
  has_many :blog_pages, class_name: 'CMS::BlogPage', foreign_key: :author_id
  has_many :audits, dependent: :destroy, foreign_key: :user_id
  has_many :user_sessions, class_name: 'UserSession', dependent: :destroy

  before_create :build_profile
  after_update :enroll_to_default_oread_apps, if: :is_approved?
  after_update :audit_password_change, if: :needs_password_change_audit?
  after_update :send_approval_mail, if: :is_approved?
  after_create :send_admin_mail

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


  def active_for_authentication? 
    super && approved? 
  end 
  
  def inactive_message 
    if !approved? 
      :not_approved 
    else 
      super # Use whatever other message 
    end 
  end

  def send_admin_mail
    AdminMailer.new_user_waiting_for_approval(self).deliver
  end

  def send_approval_mail
    UserMailer.account_approved(self).deliver
  end

  def self.send_reset_password_instructions(attributes={})
    recoverable = find_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
    if !recoverable.approved?
      recoverable.errors[:base] << I18n.t("devise.failure.not_approved")
    elsif recoverable.persisted?
      recoverable.send_reset_password_instructions
    end
    recoverable
  end

  def enroll_to_default_oread_apps
    Oread::Application.where(enroll_users_default: true).each do |app|
      self.oread_access_enrollments << Oread::AccessEnrollment.new(application: app, creator: self)
    end
    return true
  end

  def activate_session(options = {})
    new_session = user_sessions.new
    new_session.session_id = SecureRandom.hex(127)
    new_session.ip = options[:ip] if options[:ip]
    new_session.user_agent = options[:user_agent] if options[:user_agent]
    new_session.save
    purge_old_sessions
    Audit.create!(user: self, actor: self, action: "user.login", action_description: "Originated from #{new_session.ip}", actor_ip: self.last_sign_in_ip)
    new_session.session_id
  end

  def exclusive_session(session_id)
    user_sessions.where('session_id != ?', session_id).delete_all
  end

  def session_active?(session_id)
    user_sessions.where(session_id: session_id).exists?
  end

  def purge_old_sessions
    user_sessions.order('created_at desc').offset(10).destroy_all
  end

  private
    def is_approved?
      approved_changed? && approved?
    end
  
    def needs_password_change_audit?
      encrypted_password_changed? && persisted?
    end
     
    def audit_password_change
      Audit.create!(user: self, actor: self, action: "user.password_changed", actor_ip: self.last_sign_in_ip)
    end

end
