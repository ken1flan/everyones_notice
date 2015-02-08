class ActivitiesController < ApplicationController
  PAR_PAGE = 10

  def index
    @activities = Activity.related_user(current_user).
      default_order.
      page(params[:page]).per(PAR_PAGE)
  end

  def all
    @activities = Activity.joins(:notice, :user).
      default_order.
      page(params[:page]).per(PAR_PAGE)

    render "index"
  end
end
