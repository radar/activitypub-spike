class SessionsController < ApplicationController
  def new
  end

  def create
    session[:current_actor_id] = Actor.find_by(username: params[:username])
    redirect_to root_path
  end
end
