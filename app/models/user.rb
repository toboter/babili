# Account

class User < ApplicationRecord
  has_many :oread_access_tokens, class_name: 'Oread::AccessToken', foreign_key: 'resource_owner_id', dependent: :destroy
  has_many :oread_access_enrollments, class_name: 'Oread::AccessEnrollment', foreign_key: 'enrollee_id', dependent: :destroy
  has_many :oread_token_applications, through: :oread_access_tokens, source: :application
  has_many :oread_enrolled_applications, through: :oread_access_enrollments, source: :application
  has_many :oread_application_ownerships, class_name: 'Oread::Application', as: :owner

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
  
  attr_accessor :slug

  has_many :access_grants, class_name: "Doorkeeper::AccessGrant",
    foreign_key: :resource_owner_id,
    dependent: :delete_all
  has_many :access_tokens, class_name: "Doorkeeper::AccessToken",
    foreign_key: :resource_owner_id,
    dependent: :delete_all
  has_many :applications, class_name: 'Doorkeeper::Application', as: :owner
  has_many :personal_access_tokens, foreign_key: :resource_owner_id
  has_many :audits, dependent: :destroy, foreign_key: :user_id
  has_many :user_sessions, class_name: 'UserSession', dependent: :destroy
  belongs_to :person

  before_validation(on: :create) do
    hero = Person.create(family_name: slug)
    self.person = hero # Handler.create(name: slug)
  end
  after_update :enroll_to_default_oread_apps, if: :is_approved?
  after_update :audit_password_change, if: :needs_password_change_audit?
  after_update :send_approval_mail, if: :is_approved?
  after_create :send_admin_mail

  validates :slug, :person, presence: true, on: :create
  delegate :name, to: :person

  def active_for_authentication? 
    super && approved? 
  end 

  def enroll_to_default_oread_apps
    Oread::Application.where(enroll_users_default: true).each do |app|
      self.oread_access_enrollments << Oread::AccessEnrollment.new(application: app, creator: self)
    end
    return true
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
