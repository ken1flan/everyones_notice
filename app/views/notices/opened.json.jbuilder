json.error_message @error_message
if @notice.present?
  json.id @notice.id
  json.evaluation_value @evaluation_value
  json.opened_count @notice.reputation_for(:opened).to_i
end
