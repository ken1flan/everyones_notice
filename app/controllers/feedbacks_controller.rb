# == Schema Information
#
# Table name: feedbacks
#
#  id         :integer          not null, primary key
#  body       :text             not null
#  user_id    :integer          not null
#  url        :string
#  status     :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_feedbacks_on_status      (status)
#  index_feedbacks_on_updated_at  (updated_at)
#  index_feedbacks_on_user_id     (user_id)
#

class FeedbacksController < ApplicationController
  before_action :set_feedback, only: [:show]
  before_action :redirect_no_user_manager, only: [:index, :show]

  PAR_PAGE = 10

  def index
    @feedbacks = Feedback.
      order("created_at DESC").
      page(params[:page]).per(PAR_PAGE)
  end

  def show
  end

  def create
    @feedback = Feedback.new(feedback_params)
    @feedback.user = current_user

    @feedback.save
  end

  private
    def set_feedback
      @feedback = Feedback.find(params[:id])
    end

    def feedback_params
      params.require(:feedback).permit(:body)
    end

    def redirect_no_user_manager
      not_found unless can_manage_users?
    end
end
