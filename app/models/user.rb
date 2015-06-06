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

class User < ActiveRecord::Base
  belongs_to :club
  has_many :identities, dependent: :destroy
  has_many :notices
  has_many :notice_read_users
  has_many :read_notices, through: :notice_read_users, source: :notice
  has_many :replies
  has_many :approvals
  has_many :activities
  has_many :feedbacks
  has_one :invitation
  has_many :post_images
  has_many :advertisements

  validates :nickname,
    presence: true,
    length: { maximum: 64 }

  validates :club_id,
    presence: true,
    numericality: { allow_blank: true, greater_than: 0 }

  validates :admin,
    inclusion: { allow_blank: true, in: [true, false] }

  validates :icon_url,
    length: { maximum: 255 }

  validates :belonging_to,
    length: { maximum: 64 }

  def unread_notices
    Notice.where.not(id: read_notices.pluck(:id))
  end

  def draft_notices
    Notice.where(user_id: id, published_at: nil)
  end

  def notices_count
    notices.displayable.count
  end

  def replies_count
    replies.count
  end

  def liked_count
    reputation_for(:total_likes).to_i
  end

  def thumbup_count
    300
  end

  def activities_for_heatmap(
    start_date = 5.month.ago.beginning_of_month,
    end_date = Time.zone.now)

    activities.where(
      type_id: [Activity.type_ids[:notice], Activity.type_ids[:reply]],
      created_at: [start_date..end_date]).
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
    icon_url = auth[:info][:image]
    user = create!(nickname: nickname, club_id: invitation.club_id, icon_url: icon_url)
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
