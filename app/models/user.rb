class User < ApplicationRecord
  has_many :followings, foreign_key: :user_id
  has_many :followers, through: :followings

  has_many :sent_messages, foreign_key: :from_id
  has_many :received_messages, foreign_key: :to_id
end
