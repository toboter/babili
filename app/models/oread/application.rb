class Oread::Application < ApplicationRecord
  include ImageUploader[:image]
  
  validates :name, :uid, :collection_classes, :host, :port, presence: true
  validates :name, uniqueness: true

  belongs_to :owner, polymorphic: true
  
  has_many :access_tokens, dependent: :delete_all, class_name: 'Oread::AccessToken'
  has_many :token_holders, through: :access_tokens, source: :resource_owner
  has_many :access_enrollments, dependent: :delete_all, class_name: 'Oread::AccessEnrollment'
  has_many :enrollees, through: :access_enrollments, source: :enrollee
  has_many :collection_classes, class_name: 'RepositoryClass', dependent: :destroy, foreign_key: :repository_id

  accepts_nested_attributes_for :collection_classes, reject_if: :all_blank, allow_destroy: true

  def url
    "#{host}#{':'+port.to_s if port}#{search_path}"
  end

  def app_url
    "#{host}#{':'+port.to_s if (port && port != 80)}"
  end

end
