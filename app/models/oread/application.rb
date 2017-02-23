class Oread::Application < ApplicationRecord
  self.table_name = :oread_applications
  mount_uploader :image_data, OreadApplicationUploader
  
  validates :name, :search_path, :host, presence: true

  belongs_to :owner, polymorphic: true
  has_many :accessibilities, dependent: :delete_all, class_name: 'OreadAccessibility', foreign_key: 'oread_application_id'
  has_many :projects, through: :accessibilities, class_name: 'Project'
  has_many :access_tokens, dependent: :delete_all, class_name: 'Oread::AccessToken'
  
  def url
    "#{host}#{':'+port if port}#{search_path}"
  end
end
