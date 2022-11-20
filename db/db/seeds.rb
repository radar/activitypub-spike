radar = User.create!(username: "radar")
mdhoad = User.create!(username: "mdhoad")

100.times do |i|
  User.create!(username: "example-user-#{i}")
end

radar.followers << mdhoad
radar.followers << User.where("username like 'example-user-%'")
