module ApplicationHelper
  def history_back_button
    %Q(<a class="btn btn-default" href="javascript:history.back();">戻る</a>).html_safe
  end

  def user_nickname(user)
    if user == current_user
      "あなた"
    else
      user.nickname + "さん"
    end
  end
end
