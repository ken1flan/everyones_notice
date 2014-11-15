class TopController < ApplicationController
  def index
    # TODO: ちゃんと書く
    @notices = Notice.all
  end

  def current_user_activities
    render json: current_user.activities_for_heatmap
  end

  def current_club_activities
    render json: current_user.club.activities_for_heatmap
  end
end
