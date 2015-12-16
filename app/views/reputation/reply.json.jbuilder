json.error_message @error_message
if @reply.present?
  json.id @reply.id
  json.evaluation_value @evaluation_value
  json.likes_count @reply.like_number
end
