module Opened
  def opened_by?(user)
    evaluation = evaluations.where(reputation_name: :opened, source_id: user.id).first
    evaluation.blank? || evaluation.value == 0 ? false : true
  end

  def open_number
    reputation_for(:opened).to_i
  end
end
