module ActivityDecorator
  include CommonDecorator

  def title
    advertisement? ? advertisement.title : notice.title
  end

  def document_path
    advertisement? ? advertisement_path(advertisement) : notice_path(notice)
  end

  def summary_html(title_langth = 15)
    summary =  "<small>#{ created_at_string } | " +
      "#{ link_to(user.nickname, user_path(user)) }さんは" +
      "「#{ link_to(truncate(title, length: title_langth), document_path) }」" +
      if notice? || advertisement?
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
