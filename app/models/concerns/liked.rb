module Liked
  def liked_by?(user)
    evaluation = evaluations.where(reputation_name: :likes, source_id: user.id).first
    evaluation.blank? || evaluation.value == 0 ? false : true
  end

  def like_number
    reputation_for(:likes).to_i
  end

  # TODO: approbalに移行したら、like_numberにする
  def like_number2
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
