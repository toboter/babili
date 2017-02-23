class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
         
  has_many :oauth_applications, class_name: 'Doorkeeper::Application', as: :owner
  has_many :oread_applications, class_name: 'Oread::Application', as: :owner
  has_many :oread_access_tokens, class_name: 'Oread::AccessToken', foreign_key: 'resource_owner_id'
  has_many :memberships, dependent: :delete_all
  has_many :projects, through: :memberships
         
  def display_name
    if given_name && family_name
      [honorific_prefix, given_name, family_name, honorific_suffix].join(' ').strip
    else
      email
    end
  end
  
end
