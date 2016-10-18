class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
         
  def display_name
    if given_name && family_name
      [honorific_prefix, given_name, family_name, honorific_suffix].join(' ').strip
    else
      email
    end
  end
  
end
