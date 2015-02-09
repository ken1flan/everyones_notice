class NoticesController < ApplicationController
  before_action :set_notice, only: [:show, :edit, :update, :destroy, :opened, :not_opened]
  after_action :opened_by_current_user, only: [:show, :unread]

  PAR_PAGE = 10

  # GET /notices
  # GET /notices.json
  def index
    @notices = Notice.
      displayable.
      default_order.
      page(params[:page]).per(PAR_PAGE)
  end

  # GET /notices/1
  # GET /notices/1.json
  def show
  end

  # GET /notices/new
  def new
    @notice = Notice.new
  end

  # GET /notices/1/edit
  def edit
    not_found unless @notice.user == current_user
  end

  # POST /notices
  # POST /notices.json
  def create
    @notice = Notice.new(notice_params)
    @notice.published_at = Time.zone.now if params[:publish].present?
    @notice.user = current_user

    respond_to do |format|
      if @notice.save
        format.html { redirect_to @notice, notice: 'Notice was successfully created.' }
        format.json { render :show, status: :created, location: @notice }
        format.js
      else
        format.html { render :new }
        format.json { render json: @notice.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PATCH/PUT /notices/1
  # PATCH/PUT /notices/1.json
  def update
    not_found unless @notice.user == current_user

    @notice.attributes = notice_params
    @notice.published_at = Time.zone.now if params[:publish].present?

    respond_to do |format|
      if @notice.save
        format.html { redirect_to @notice, notice: 'Notice was successfully updated.' }
        format.json { render :show, status: :ok, location: @notice }
        format.js
      else
        format.html { render :edit }
        format.json { render json: @notice.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # DELETE /notices/1
  # DELETE /notices/1.json
  def destroy
    @notice.destroy
    respond_to do |format|
      format.html { redirect_to notices_url, notice: 'Notice was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def opened
    opened_by_current_user
  end

  def not_opened
    @notice.read_users.delete current_user
    render "opened"
  end

  def todays
    @notices = Notice.
      displayable.
      today.
      default_order.
      page(params[:page]).per(PAR_PAGE)
    render "index"
  end

  def unread
    @notice = current_user.unread_notices.
      displayable.
      default_order.
      first
  end

  def draft
    @notices = current_user.draft_notices.
      default_order.
      page(params[:page]).per(PAR_PAGE)
    render "index"
  end

  def watched
    @notices = Notice.weekly_watched.page(params[:page]).per(PAR_PAGE)
    render "index"
  end

  def searched_by_word
    @search = Notice.search do
      fulltext params[:search]
      with :published, true
      paginate page: params[:page], per_page: PAR_PAGE
    end

    @notices = @search.results
    render "index"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_notice
      @notice = Notice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def notice_params
      params.require(:notice).permit(:title, :body, :tags_string)
    end

    def opened_by_current_user
      return if @notice.blank?
      unless @notice.read_users.include? current_user
        @notice.read_users << current_user
      end
    end
end
