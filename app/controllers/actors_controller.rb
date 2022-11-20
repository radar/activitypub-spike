class ActorsController < ApplicationController
  def outbox
    activity_params = params[:activity].permit!.to_h

    schema = find_schema(activity_params[:type])
    result = schema.(activity_params)

    if result.failure?
      return render json: result.errors(full: true).to_h, status: 422
    end

    activity = if activity_params[:type] == "Message"
      ActivityWrapper::Message.wrap(activity_params)
    else
      ActivityPub::Activity.new(activity_params)
    end

    unless activity.actor
      return head :not_found
    end

    ActivityProcessor.perform_async(activity.to_json)
    head :ok
  end

  private def find_schema(type)
    case type
    when "Message"
      MessageSchema
    else
      ActivitySchema
    end
  end
end
