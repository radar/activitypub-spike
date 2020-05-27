class UsersController < ApplicationController
  def outbox
    actor = params.dig(:activity, :actor, :name)

    user = User.find_by(username: actor)
    content = params.dig(:activity, :object, :content)
    published = params.dig(:activity, :published)

    user.sent_messages.create!(
      created_at: published,
      content: content,
      to: Array.wrap(params.dig(:activity, :to))
    )

    user.followers.each do |follower|
      follower.received_messages.create!(
        created_at: published,
        from: user,
        content: content
      )
    end

    head :ok
  end
end
