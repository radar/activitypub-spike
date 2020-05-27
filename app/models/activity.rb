module Types
  include Dry.Types()
end

class Actor < Dry::Struct
  transform_keys(&:to_sym)

  attribute? :id, Types::String
  attribute :type, Types::String
  attribute :name, Types::String
end

class ActivityObject < Dry::Struct
  transform_keys(&:to_sym)

  attribute? :id, Types::String
  attribute :content, Types::String
end

class Activity < Dry::Struct
  transform_keys(&:to_sym)

  def actor_name
    actor.is_a?(Actor) ? actor.name : actor
  end

  def actor
    @actor ||= begin
      if attributes[:actor].id
        GlobalID::Locator.locate attributes[:actor].id
      else
        User.find_by(username: attributes[:actor].name)
      end
    end
  end

  attribute :type, Types::String
  attribute :actor, Types::String | Actor
  attribute :object, ActivityObject
  attribute? :published, Types::JSON::DateTime
  attribute :to, Types::String | Types::Array
end
