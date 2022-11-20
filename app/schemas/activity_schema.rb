require 'dry/schema'

ActorSchema = Dry::Schema.Params do
  required(:type) { eql?("User") }
  required(:name) { str? }
end

ActivitySchema = Dry::Schema.Params do
  required(:@context) { eql?("https://www.w3.org/ns/activitystreams") }
  required(:actor) { str? | (hash? & schema(ActorSchema)) }
end
