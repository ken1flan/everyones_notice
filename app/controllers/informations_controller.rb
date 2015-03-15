class InformationsController < ApplicationController
  before_action :set_information, only: [:show, :edit, :update, :destroy]

  PAR_PAGE = 10

  def index
    @informations = Information.
      order("created_at DESC").
      page(params[:page]).per(PAR_PAGE)
  end

  def show
  end

  def new
    @information = Information.new
  end

  def create
    @information = Information.create(information_params)

    if @information.save
      redirect_to @information, notice: "Information was successfully created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @information.save
      redirect_to @information, notice: "Information was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @information.destroy
    redirect_to informations_url, notice: "Information was successfully destroyed."
  end

  private
    def set_information
      @invitation = Information.find(params[:id])
    end

    def information_params
      params.
        require(:information).
        permit(:title, :description, :body, :user_id, :started_on, :ended_on)
    end
end
