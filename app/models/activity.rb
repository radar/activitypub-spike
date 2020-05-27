module Types
  include Dry.Types()
end

class Actor < Dry::Struct
  transform_keys(&:to_sym)

  attribute :type, Types::String
  attribute :name, Types::String
end

class ActivityObject < Dry::Struct
  transform_keys(&:to_sym)

  attribute :content, Types::String
end

class Activity < Dry::Struct
  transform_keys(&:to_sym)

  def actor_name
    actor.is_a?(Actor) ? actor.name : actor
  end

  attribute :actor, Types::String | Actor
  attribute :object, ActivityObject
  attribute :published, Types::JSON::DateTime
  attribute :to, Types::String | Types::Array
end
