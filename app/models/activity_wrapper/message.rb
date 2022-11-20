module ActivityWrapper
  class Message
    def self.wrap(params)
      user = GlobalID::Locator.locate params[:attributedTo]
      ActivityPub::Activity.new(
        "@context": params[:@context],
        type: "Create",
        to: params[:to],
        actor: {
          id: params[:attributedTo],
          type: "User",
          name: user.username,
        },
        object: {
          type: "Message",
          attributedTo: params[:attributedTo],
          to: Array.wrap(params[:to]),
          content: params[:content]
        }
      )
    end
  end
end
