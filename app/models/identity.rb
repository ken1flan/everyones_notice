class Identity < ActiveRecord::Base
  belongs_to :user

  PROVIDERS = %w(twitter google_oauth2 facebook)
end
