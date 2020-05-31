require 'dry/schema'
# A Link is an indirect, qualified reference to a resource identified by a URL. 
# The fundamental model for links is established by [ RFC5988]. Many of the 
# properties defined by the Activity Vocabulary allow values that are either 
# instances of Object or Link. When a Link is used, it establishes a qualified 
# relation connecting the subject (the containing object) to the resource 
# identified by the href. Properties of the Link are properties of the 
# reference as opposed to properties of the resource.
# https://www.w3.org/TR/activitystreams-vocabulary/#dfn-link
LinkSchema = Dry::Schema.Params do
  required(:type).value(eql?: "Link")
  required(:href).filled(:string)

  optional(:hreflang).value(type?: String)
  optional(:rel).value(type?: String)
  optional(:mediaType).value(included_in?: Mime::EXTENSION_LOOKUP.values.map(&:to_s).uniq)
  optional(:name).value(type?: String)
  optional(:height).value(gt?: 0)
  optional(:width).value(gt?: 0)
end