require 'dry/schema'

ActorSchema = Dry::Schema.Params do
  required(:type).value(included_in?: %w[Application Group Organization Person Service])
  required(:name) { str? }
end

ActivitySchema = Dry::Schema.Params do
  required(:@context) { eql?("https://www.w3.org/ns/activitystreams") }
  required(:actor) { str? | (hash? & schema(ActorSchema)) }
end
