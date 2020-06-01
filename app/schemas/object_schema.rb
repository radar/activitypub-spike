require 'dry/schema'

NestedObject = Dry::Schema.Params do
  required(:type).value(type?: String)
  optional(:content).value(type?: String)
  optional(:url).value(type?: String)
  optional(:name).value(type?: String)
  optional(:summary).value(type?: String)
  optional(:published).value(type?: String)
  optional(:startTime).value(type?: String)
  optional(:endTime).value(type?: String)
  optional(:updated).value(type?: String)
  optional(:startTime).value(type?: String)
end

# Describes an object of any kind. The Object type serves as the base 
# type for most of the other kinds of objects defined in the Activity Vocabulary, 
# including other Core types such as Activity, IntransitiveActivity, 
# Collection and OrderedCollection. 
# https://www.w3.org/ns/activitystreams#Object
ObjectSchema = Dry::Schema.Params do
  # TODO: Need to handle situation where a nested value in the object 
  # can be either an object itself, a child of an object, a link
  # a child of a link or an array containing any combination of above
  # TODO: Currently handing date time values as strings. Need to fix
  required(:@context) { eql?("https://www.w3.org/ns/activitystreams") }
  required(:type).value(type?: String)
  optional(:name).value(type?: String)
  optional(:content).value(type?: String)
  optional(:published).value(type?: String)
  optional(:endTime).value(type?: String)
  optional(:updated).value(type?: String)
  optional(:startTime).value(type?: String)
  optional(:mediaType).value(included_in?: Mime::EXTENSION_LOOKUP.values.map(&:to_s).uniq)

  optional(:attachment).maybe(:array).each do |attachment|
    (hash? & schema(LinkSchema)) | (hash? & schema(NestedObject))
  end

  optional(:attributedTo).maybe(:array).each do |attachment|
    (hash? & schema(LinkSchema)) | (hash? & schema(NestedObject)) | str?
  end

  optional(:audience).maybe(:array).each do |attachment|
    (hash? & schema(LinkSchema)) | (hash? & schema(NestedObject)) | str?
  end
  
end
