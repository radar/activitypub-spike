class SentMessage < ApplicationRecord
  belongs_to :from, class_name: "User"
end
