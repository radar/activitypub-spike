class UsersController < ApplicationController
  def outbox
    result = ActivitySchema.(params[:activity].permit!.to_h)

    if result.failure?
      return render json: result.errors(full: true).to_h, status: 422
    end

    actor = User.find_by(username: params.dig(:activity, :actor, :name))

    unless actor
      return head :not_found
    end

    ActivityProcessor.perform_async(params[:activity].to_json)
    head :ok
  end
end
