class User < ActiveRecord::Base
  validates :email, presence: true, length: { maximum: 40 }
  validates :password, presence: true, length: { maximum: 40 }

  has_many :songs

  attr_accessor :password_confirmation

  validate :check_password

  def check_password
    if password != password_confirmation
      errors.add(:password, 'The passwords you have put in do not match')
    end
  end

end