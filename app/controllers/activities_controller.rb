# == Schema Information
#
# Table name: activities
#
#  id                       :integer          not null, primary key
#  type_id                  :integer
#  user_id                  :integer
#  notice_id                :integer
#  reply_id                 :integer
#  created_at               :datetime
#  updated_at               :datetime
#  advertisement_id         :integer
#  activity_recordable_id   :integer
#  activity_recordable_type :string
#
# Indexes
#
#  index_activities_on_activity_recordable_reference  (activity_recordable_type,activity_recordable_id)
#  index_activities_on_created_at                     (created_at)
#  index_activities_on_notice_id                      (notice_id)
#  index_activities_on_reply_id                       (reply_id)
#  index_activities_on_type_id                        (type_id)
#  index_activities_on_user_id                        (user_id)
#  index_activities_unique_key                        (type_id,user_id,notice_id,reply_id) UNIQUE
#

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
      joins_related_models.
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
