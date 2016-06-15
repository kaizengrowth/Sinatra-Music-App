class User < ActiveRecord::Base
  has_many :messages
  has_many :upvotes

  has_secure_password

  validates :email, presence: true

end
