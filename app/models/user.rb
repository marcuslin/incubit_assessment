class User < ActiveRecord::Base
  has_secure_password
  validates :password, presence: true, length: { minimum: 8 }, allow_nil: true

  has_secure_token :reset_password_token

  validates :email, presence: true
  validates :email, uniqueness: true
  validates_format_of :email,:with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/

  validates :name, presence: true, length: { minimum: 5 }, on: :update
end
