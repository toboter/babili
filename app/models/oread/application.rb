class Oread::Application < ApplicationRecord
  include ImageUploader[:image]
  
  validates :name, :search_path, :host, :port, presence: true
  validates :name, uniqueness: true

  belongs_to :owner, polymorphic: true
  
  has_many :access_tokens, dependent: :delete_all, class_name: 'Oread::AccessToken'
  has_many :token_holders, through: :access_tokens, source: :resource_owner
  has_many :access_enrollments, dependent: :delete_all, class_name: 'Oread::AccessEnrollment'
  has_many :enrollees, through: :access_enrollments, source: :enrollee

  def url
    "#{host}#{':'+port.to_s if port}#{search_path}"
  end

  def app_url
    "#{host}#{':'+port.to_s if (port && port != 80)}"
  end

end
