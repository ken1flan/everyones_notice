module ActivityDecorator
  include CommonDecorator

  def summary_html
    summary =  "#{ created_at_string } | " +
      "#{ link_to(user.nickname, user_path(user)) }さんは" +
      "「#{ link_to(notice.title, notice_path(notice)) }」" +
      if notice?
        "を書きました。"
      elsif reply?
        "に返信しました。"
      elsif thumbup_notice?
        "にいいねしました。"
      elsif thumbup_reply?
        "の返信にいいねしました。"
      else
        "?"
      end
    summary.html_safe
  end
end
