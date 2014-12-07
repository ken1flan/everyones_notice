class TopController < ApplicationController
  PAGE_PAR = 10

  def index
    @notices = Notice.all
  end

  def current_club_activities
    render json: current_user.club.activities_for_heatmap
  end
end
