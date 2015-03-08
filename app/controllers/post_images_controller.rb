class PostImagesController < ApplicationController
  before_action :set_post_image, only: [:show]

  PAR_PAGE = 10

  def index
    @post_images = PostImage.default_order.page(params[:page]).per(PAR_PAGE)
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
