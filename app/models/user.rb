# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  user_name       :string(255)      not null
#  password_digest :string(255)      not null
#  created_at      :datetime
#  updated_at      :datetime
#

class User < ActiveRecord::Base
  validates :password, length: { minimum: 6, allow_nil: true }
  validates :user_name, presence: true, uniqueness: true

  attr_reader :password

  has_many :cats
  has_many(
  :tokens,
  :class_name => "UserToken",
  :foreign_key => :user_id,
  :primary_key => :id)

  def reset_session_token!
    new_session_token = SecureRandom.urlsafe_base64(16)

    token = UserToken.new(user_id: self.id)
    token.session_token = new_session_token
    token.save!
    token.session_token
  end

  def password=(unencrypted_password)
    @password = unencrypted_password
    self.password_digest = BCrypt::Password.create(unencrypted_password)
  end

  def is_password?(unencrypted_password)
    BCrypt::Password.new(self.password_digest).is_password?(unencrypted_password)
  end

  def self.find_by_credentials(params)
    user = User.find_by(user_name: params[:user_name])
    return user if user && user.is_password?(params[:password])
    nil
  end
end
