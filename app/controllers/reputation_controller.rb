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
  end
end
