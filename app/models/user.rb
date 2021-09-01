class User < ApplicationRecord
  attr_accessor :remember_token
  before_save {self.email = email.downcase}
  valid_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true, length: {maximum: 50}
  validates :email, presence: true, length: {maximum: 255},
            format: {with: valid_regex}, uniqueness: true
  has_secure_password
  validates :password, presence: true, length: {minimum: 6}

  # remembers the user in the DB for persistent sessions
  def remember
    self.remember_token = User.new_token
    update_attribute( :remember_digest, User.digest(remember_token))
  end

  # Returns True if given token matches the digest
  def authenticated?(remember_token)
    return false if remember_digest.nil? # Prevents BCrypt exception
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # forget user
  def forget
    update_attribute :remember_digest, nil
  end

  #opens up the Users sigleton class
  class << self
    # Returns a hash digest of a given string
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    # Returns a random token
    def new_token
      SecureRandom.urlsafe_base64
    end
  end
end
