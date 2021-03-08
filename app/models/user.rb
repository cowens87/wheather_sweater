require 'securerandom'

class User < ApplicationRecord
  before_create :set_api_key
  validates :email, uniqueness: true, presence: true
  validates :password, presence: true
  validates :password_confirmation, presence: true

  has_secure_password

  private

  def set_api_key
    self.api_key = generate_key
  end

  def generate_key
    loop do
      key = SecureRandom.uuid
      break key unless User.where(api_key: key).exists?
    end
  end
end