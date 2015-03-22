class AdvertisementsController < ApplicationController
  before_action :set_advertisement, only: [:show, :edit, :update, :destroy]
  before_action :not_found_unless_author, only: [:edit, :update, :destroy]
  PER_PAGE=10

  def index
    @advertisements = Advertisement.
      displayable.
      page(params[:page]).per(PER_PAGE)
  end

  def all
    @advertisements = Advertisement.page(params[:page]).per(PER_PAGE)
    render "advertisements/index"
  end

  def show
  end

  def new
    @advertisement = Advertisement.new
  end

  def edit
  end

  def create
    @advertisement = Advertisement.new(advertisement_params)
    @advertisement.user = current_user

    if @advertisement.save
      redirect_to @advertisement,
        notice: 'Advertisement was successfully created.'
    else
      render :new
    end
  end

  def update
    if @advertisement.update(advertisement_params)
      redirect_to @advertisement,
        management: true,
        notice: 'Advertisement was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @advertisement.destroy

    redirect_to all_advertisements_path, notice: 'Advertisement was successfully destroyed.'
  end

  def random_list
    @advertisements = Advertisement.displayable.limit(params[:num])
  end

  private
    def set_advertisement
      @advertisement = Advertisement.find(params[:id])
    end

    def advertisement_params
      params.
        require(:advertisement).
        permit(:title, :summary, :body, :started_on, :ended_on)
    end

    def not_found_unless_author
      not_found unless @advertisement.user == current_user
    end
end
