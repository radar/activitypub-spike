class ApplicationController < ActionController::Base
  def current_actor
    @current_actor ||= Actor.find(session[:current_action_id])
  end
end
