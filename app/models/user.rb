class User < ActiveRecord::Base
  has_many :messages

  has_secure_password

  validates :email, presence: true

end
