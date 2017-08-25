class Oread::Application < ApplicationRecord
  self.table_name = :oread_applications
  include ImageUploader[:image]
  
  validates :name, :search_path, :host, presence: true
  validates :name, uniqueness: true

  belongs_to :owner, polymorphic: true
  
  has_many :access_tokens, dependent: :delete_all, class_name: 'Oread::AccessToken'
  has_many :users, through: :access_tokens, source: :resource_owner
  
  def url
    "#{host}#{':'+port.to_s if port}#{search_path}"
  end
end
