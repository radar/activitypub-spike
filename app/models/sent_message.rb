class SentMessage < ApplicationRecord
  belongs_to :from, class_name: "User"

  has_many :delivered_messages, class_name: "ReceivedMessage", foreign_key: :source_id
end
