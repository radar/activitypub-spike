MessageSchema = Dry::Schema.Params do
  required(:@context) { eql?("https://www.w3.org/ns/activitystreams") }
  required(:type) { eql?("Message") }
  required(:to).value(array[:string])
end
