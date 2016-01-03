# == Schema Information
#
# Table name: post_images
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  title      :string           not null
#  image      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_post_images_on_created_at  (created_at)
#  index_post_images_on_user_id     (user_id)
#

class PostImagesController < ApplicationController
  before_action :set_post_image, only: [:show]

  PAR_PAGE = 10

  def index
    @post_images = PostImage.
      where(user: current_user).
      default_order.
      page(params[:page]).per(PAR_PAGE)
  end

  def all
    @post_images = PostImage.
      default_order.
      page(params[:page]).per(PAR_PAGE)

    render "post_images/index"
  end

  def show
  end

  def new
    @post_image = PostImage.new
  end

  def create
    @post_image = PostImage.new(post_image_params)
    @post_image.user = current_user
    if @post_image.save
      redirect_to @post_image, notice: 'Image was successfully created.'
    else
      render :new
    end
  end

  private
    def set_post_image
      @post_image = PostImage.find(params[:id])
    end

    def post_image_params
      params.require(:post_image).permit(:title, :image, :image_cache)
    end
end
