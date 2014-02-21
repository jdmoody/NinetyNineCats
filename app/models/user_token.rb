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

  belongs_to :user
end
