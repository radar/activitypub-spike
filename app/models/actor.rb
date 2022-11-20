class Actor < ApplicationRecord
  has_many :followings
  has_many :followers, through: :followings

  has_many :sent_messages, foreign_key: :from_id
  has_many :received_messages, foreign_key: :to_id

  BASE_URL = "https://activitypub.local"

  def followers_url
    URI.join(BASE_URL, "/#{username}/followers").to_s
  end
end
