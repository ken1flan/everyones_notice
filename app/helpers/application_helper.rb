module ApplicationHelper
  def history_back_button
    %(<a class="btn btn-default" href="javascript:history.back();">戻る</a>).html_safe
  end

  def user_nickname(user)
    if user == current_user
      'あなた'
    else
      user.nickname + 'さん'
    end
  end

  def set_google_oauth2?
    Rails.application.secrets.google_client_id.present? && Rails.application.secrets.google_client_secret.present?
  end

  def set_twitter_oauth2?
    Rails.application.secrets.twitter_consumer_key.present? && Rails.application.secrets.twitter_consumer_secret.present?
  end

  def set_facebook_oauth2?
    Rails.application.secrets.facebook_app_id.present? && Rails.application.secrets.facebook_app_secret.present?
  end

  def summarize(str)
    truncate(str, length: 50, ommistion: '...')
  end
end
