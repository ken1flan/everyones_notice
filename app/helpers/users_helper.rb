# == Schema Information
#
# Table name: users
#
#  id           :integer          not null, primary key
#  nickname     :string(255)
#  club_id      :integer          default(1), not null
#  admin        :boolean          default(FALSE), not null
#  created_at   :datetime
#  updated_at   :datetime
#  icon_url     :string(255)
#  belonging_to :string
#
# Indexes
#
#  index_users_on_club_id  (club_id)
#

module UsersHelper
end
