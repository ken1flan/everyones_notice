module ActivityDecorator
  include CommonDecorator

  def summary_html
    summary =  "<small>#{ created_at_string } | " +
      "#{ link_to(user.nickname, user_path(user)) }さんは" +
      "「#{ link_to(truncate(notice.title, length: 15), notice_path(notice)) }」" +
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
      end + "</small>"
    summary.html_safe
  end
end
