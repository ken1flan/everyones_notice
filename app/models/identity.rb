# == Schema Information
#
# Table name: identities
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  provider   :string(255)
#  uid        :string(255)
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_identities_on_provider_and_uid  (provider,uid) UNIQUE
#  index_identities_on_user_id           (user_id) UNIQUE
#

class Identity < ActiveRecord::Base
  belongs_to :user

  PROVIDERS = %w(twitter google_oauth2 facebook).freeze
end
