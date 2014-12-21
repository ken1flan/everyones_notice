class ReputationController < ApplicationController
  def notice
    if user_signed_in?
      @notice = Notice.find(params[:id])
      @evaluation_value = params[:up_down] == 'down' ? 0 : 1
      @notice.add_or_update_evaluation(:likes, @evaluation_value, current_user)
    else
      # TODO: ja.ymlを使うようにする
      @error_message = 'ログインが必要です'
    end

    register_thumbup_notice_activity if params[:up_down] == 'up'
  end

  def reply
    if user_signed_in?
      @reply = Reply.find(params[:id])
      @evaluation_value = params[:up_down] == 'down' ? 0 : 1
      @reply.add_or_update_evaluation(:likes, @evaluation_value, current_user)
    else
      # TODO: ja.ymlを使うようにする
      @error_message = 'ログインが必要です'
    end

    register_thumbup_reply_activity if params[:up_down] == 'up'
  end

  private
    def register_thumbup_notice_activity
      return if Activity.find_by(
        type_id: Activity.type_ids[:thumbup_notice],
        notice_id: @notice.id).present?

      begin
        activity = Activity.new
        activity.type_id = Activity.type_ids[:thumbup_notice]
        activity.user_id = current_user.id
        activity.notice_id = @notice.id
        activity.save!
      rescue
        logger.warn("failed to register thumbup notice(id: #{@notice.id})")
      end
    end

    def register_thumbup_reply_activity
      return if Activity.find_by(
        type_id: Activity.type_ids[:thumbup_reply],
        reply_id: @reply.id).present?

      begin
        activity = Activity.new
        activity.type_id = Activity.type_ids[:thumbup_reply]
        activity.user_id = current_user.id
        activity.notice_id = @reply.notice_id
        activity.reply_id = @reply.id
        activity.save!
      rescue
        logger.warn("failed to register thumbup reply(id: #{@reply.id})")
      end
    end
end
