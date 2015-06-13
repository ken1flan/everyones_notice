json.error_message @error_message
if @notice.present?
  json.id @notice.id
  json.evaluation_value @evaluation_value
  json.likes_count @notice.like_number
end
