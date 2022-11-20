class ReceivedMessage < ApplicationRecord
  belongs_to :from, class_name: "Actor"
  belongs_to :to, class_name: "Actor"

  belongs_to :source, class_name: "SentMessage"
end
