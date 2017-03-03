class Oread::Application < ApplicationRecord
  self.table_name = :oread_applications
  include ImageUploader[:image]
  
  validates :name, :search_path, :host, presence: true
  validates :name, uniqueness: true

  belongs_to :owner, polymorphic: true
  has_many :oread_accessibilities, dependent: :delete_all, class_name: 'OreadAccessibility', foreign_key: 'oread_application_id'

  
  has_many :projects, through: :oread_accessibilities, class_name: 'Project'
  has_many :access_tokens, dependent: :delete_all, class_name: 'Oread::AccessToken'
  
  def url
    "#{host}#{':'+port.to_s if port}#{search_path}"
  end
end
