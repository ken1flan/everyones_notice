class TagsController < ApplicationController

  PAR_PAGE = 10

  def index
    @tags = Tag.page(params[:page]).per(PAR_PAGE)
  end

  def show
    @tag = Tag.find(params[:id])
    @tagged_notices = NoticeTag.
      where(tag_id: @tag.id).
      includes(:notice).
      page(params[:page]).per(PAR_PAGE)
  end
end
