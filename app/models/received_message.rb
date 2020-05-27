class ReceivedMessage < ApplicationRecord
  belongs_to :from, class_name: "User"
  belongs_to :to, class_name: "User"

  belongs_to :source, class_name: "SentMessage"
end
