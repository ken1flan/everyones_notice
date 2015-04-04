module Liked
  def liked_by?(user)
    evaluation = evaluations.where(reputation_name: :likes, source_id: user.id).first
    evaluation.blank? || evaluation.value == 0 ? false : true
  end

  def like_number
    reputation_for(:likes).to_i
  end
end
