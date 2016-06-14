class User < ActiveRecord::Base
  has_many :Songs

  has_secure_password

  validates :email, presence: true

end
