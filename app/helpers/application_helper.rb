module ApplicationHelper
  def history_back_button
    %Q(<a class="btn btn-default" href="javascript:history.back();">戻る</a>).html_safe
  end
end
