module ActivityWrapper
  class Message
    def self.wrap(params)
      user = GlobalID::Locator.locate params[:attributedTo]
      Activity.new(
        "@context": params[:@context],
        type: "Create",
        to: params[:to],
        actor: {
          id: params[:attributedTo],
          name: user.username,
        },
        object: {
          type: self.name.demodulize,
          attributedTo: Array.wrap(params[:attributedTo]),
          to: Array.wrap(params[:to]),
          content: params[:content]
        }
      )
    end
  end
end
