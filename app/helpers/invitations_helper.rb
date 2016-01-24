# == Schema Information
#
# Table name: invitations
#
#  id           :integer          not null, primary key
#  mail_address :string(255)      not null
#  message      :text
#  club_id      :integer          not null
#  user_id      :integer
#  admin        :boolean          default(FALSE), not null
#  token        :string(255)      not null
#  expired_at   :datetime         not null
#  created_at   :datetime
#  updated_at   :datetime
#

module InvitationsHelper
end
