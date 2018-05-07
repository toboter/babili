class ContactMessage
  include ActiveModel::Model
  include EmailValidatable

  attr_accessor :name, :email, :body, :sent_at

  validates :name, :body, presence: true
  validates :email, email: true, presence: true
end