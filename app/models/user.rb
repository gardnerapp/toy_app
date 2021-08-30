class User < ApplicationRecord
  before_save {self.email = email.downcase}
  valid_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true, length: {maximum: 50}
  validates :email, presence: true, length: {maximum: 255},
            format: {with: valid_regex}, uniqueness: true
  has_secure_password
  validates :password, presence: true, length: {minimum: 6}

  # Returns a hash digest of a given string
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end


end
