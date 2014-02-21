# == Schema Information
#
# Table name: user_tokens
#
#  id            :integer          not null, primary key
#  user_id       :integer          not null
#  session_token :string(255)      not null
#  created_at    :datetime
#  updated_at    :datetime
#

class UserToken < ActiveRecord::Base
  validates :session_token, presence: true, uniqueness: true
  validates :user_id, presence: true

  belongs_to :user

  def self.remove_token(token)
    user_token = UserToken.find_by(session_token: token)
    user_token.destroy
  end
end
