class UsersController < ApplicationController
  def outbox
    actor = User.find_by(username: params.dig(:activity, :actor, :name))

    unless actor
      return head :not_found
    end

    ActivityProcessor.perform_async(params[:activity].to_json)
    head :ok
  end
end
