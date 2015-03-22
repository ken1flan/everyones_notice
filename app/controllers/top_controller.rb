class TopController < ApplicationController
  PAGE_PAR = 10
  ACTIVITY_COUNT = 10

  def index
    @notices = Notice.all
    @activities = Activity.joins(:notice, :user).
      default_order.limit(ACTIVITY_COUNT)
  end

  def current_club_activities
    render json: current_user.club.activities_for_heatmap
  end
end
