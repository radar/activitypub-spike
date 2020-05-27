class UsersController < ApplicationController
  def outbox
    activity_params = params[:activity].permit!.to_h

    result = ActivitySchema.(activity_params)

    if result.failure?
      return render json: result.errors(full: true).to_h, status: 422
    end

    activity = Activity.new(activity_params)

    actor = User.find_by(username: activity.actor_name)

    unless actor
      return head :not_found
    end

    ActivityProcessor.perform_async(params[:activity].to_json)
    head :ok
  end
end
