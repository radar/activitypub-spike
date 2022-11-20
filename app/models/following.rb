class Following < ApplicationRecord
  belongs_to :actor
  belongs_to :follower, class_name: "Actor"
end
