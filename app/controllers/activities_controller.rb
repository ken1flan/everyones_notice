class ActivitiesController < ApplicationController
  PAR_PAGE = 10

  before_action :set_target_date

  def index
    @activities = Activity.
      related_user(current_user).
      between_beginning_and_end_of_day(@target_date).
      default_order.
      page(params[:page]).
      per(PAR_PAGE)
  end

  def all
    @activities = Activity.
      joins(:notice, :user).
      between_beginning_and_end_of_day(@target_date).
      default_order.
      page(params[:page]).
      per(PAR_PAGE)
    render "index"
  end

  private
    def set_target_date
      if params[:year] && params[:month] && params[:day]
        begin
          @target_date = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
        end
      end
    end
end
