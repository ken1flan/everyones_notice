# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  nickname   :string(255)
#  club_id    :integer          default(1), not null
#  admin      :boolean          default(FALSE), not null
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_users_on_club_id  (club_id)
#

class User < ActiveRecord::Base
  attr_accessible :nickname, :club_id, :admin
  belongs_to :club
  has_many :identities, dependent: :destroy
  has_many :notices
  has_many :replies
  has_one :invitation

  def activities_for_heatmap(
    start_date = 5.month.ago.beginning_of_month,
    end_date = Time.zone.now)

    notices.where(created_at: [start_date..end_date]).
      select("created_at").
      map {|n| n.created_at.to_i }.
      inject(Hash.new(0)){|h, tm| h[tm] += 1; h}.
      to_json
  end

  def self.create_with_identity(auth, token)
    invitation = Invitation.find_by(token: token)
    if invitation.blank?
      raise ActiveRecord::RecordNotFound.new('Invitation Not Found') 
    end

    nickname = auth[:info][:nickname]
    nickname ||= auth[:info][:name]
    user = create!(nickname: nickname)
    identity = Identity.create!({
      user_id: user.id,
      provider: auth[:provider],
      uid: auth[:uid]
    })

    invitation.update_attributes(user_id: user.id)

    user
  end

  def self.find_from(auth)
    user = User.joins(:identities).
      merge(Identity.where(provider: auth[:provider], uid: auth[:uid])).
      first
    if user.blank?
      raise ActiveRecord::RecordNotFound.new('User Not Found') 
    end
    user
  end
end
