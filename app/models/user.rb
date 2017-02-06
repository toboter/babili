class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
         
  has_many :oauth_applications, class_name: 'Doorkeeper::Application', as: :owner
  has_many :search_applications, class_name: 'Search::Application', foreign_key: :owner_id
  has_many :memberships, dependent: :destroy
  has_many :projects, through: :memberships
         
  def display_name
    if given_name && family_name
      [honorific_prefix, given_name, family_name, honorific_suffix].join(' ').strip
    else
      email
    end
  end
  
end
