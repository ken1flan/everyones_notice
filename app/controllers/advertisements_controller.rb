# == Schema Information
#
# Table name: advertisements
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  summary    :string           not null
#  body       :text             not null
#  started_on :date             not null
#  ended_on   :date             not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_advertisements_on_started_on_and_ended_on  (started_on,ended_on)
#  index_advertisements_on_updated_at               (updated_at)
#

class AdvertisementsController < ApplicationController
  before_action :set_advertisement, only: [:show, :edit, :update, :destroy]
  before_action :not_found_unless_author, only: [:edit, :update, :destroy]
  PER_PAGE = 10

  def index
    @advertisements = Advertisement
                      .displayable
                      .page(params[:page]).per(PER_PAGE)
  end

  def all
    @advertisements = Advertisement.page(params[:page]).per(PER_PAGE)
    render 'advertisements/index'
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
    @advertisements = Advertisement.displayable.sample(params[:num].to_i)
  end

  private

  def set_advertisement
    @advertisement = Advertisement.find(params[:id])
  end

  def advertisement_params
    params
      .require(:advertisement)
      .permit(:title, :summary, :body, :started_on, :ended_on)
  end

  def not_found_unless_author
    not_found unless @advertisement.user == current_user
  end
end
