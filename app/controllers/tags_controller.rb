# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class TagsController < ApplicationController
  PAR_PAGE = 10

  def index
    @tags = Tag
            .joins(:notice_tags)
            .select('tags.*, count(notice_tags.notice_id) as notices_count')
            .group('tags.id')
            .order('notices_count DESC')
  end

  def show
    @tag = Tag.find(params[:id])
    @tagged_notices = NoticeTag
                      .where(tag_id: @tag.id)
                      .includes(:notice)
                      .page(params[:page]).per(PAR_PAGE)
  end
end
