# == Schema Information
#
# Table name: notice_tags
#
#  id         :integer          not null, primary key
#  notice_id  :integer
#  tag_id     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_notice_tags_on_notice_id_and_tag_id  (notice_id,tag_id)
#  index_notice_tags_on_tag_id_and_notice_id  (tag_id,notice_id)
#

class NoticeTag < ActiveRecord::Base
  belongs_to :notice
  belongs_to :tag
end
