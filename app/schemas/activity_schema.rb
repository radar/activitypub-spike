require 'dry/schema'

Actor = Dry::Schema.Params do
  required(:type) { eql?("User") }
end

ActivitySchema = Dry::Schema.Params do
  required(:@context) { eql?("https://www.w3.org/ns/activitystreams") }
  required(:actor) { str? | (hash? & schema(Actor)) }
end
