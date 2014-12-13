json.error_message @error_message
if @notice.present?
  json.id @notice.id
  json.opened_or_not params[:action]
end
