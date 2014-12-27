module InvitationDecorator
  include CommonDecorator

  def expired_at_string
    expired_at.strftime "%Y/%m/%d %H:%M:%S"
  end
end
