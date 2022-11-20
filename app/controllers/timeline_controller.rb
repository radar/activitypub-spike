class TimelineController < ApplicationController
  def new
    @note = Note.new
  end
end
