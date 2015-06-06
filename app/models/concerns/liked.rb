module Liked
  def liked_by?(user)
    approvals.where(user_id:user.id, deleted: false).present?
  end

  def like_number
    approvals.where(deleted: false).count
  end

  def liked_by(user)
    approval = approvals.where(user: user).first_or_create
    approval.update_attributes(deleted: false)
  end

  def unliked_by(user)
    approval = approvals.where(user: user).first_or_create
    approval.update_attributes(deleted: true)
  end
end
