module NoticeDecorator
  include CommonDecorator

  def published_at_string
    published_at.strftime "%Y/%m/%d %H:%M:%S"
  end
end
