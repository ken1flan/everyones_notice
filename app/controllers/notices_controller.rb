class NoticesController < ApplicationController
  before_action :set_notice, only: [:show, :edit, :update, :destroy, :opened, :not_opened]

  # GET /notices
  # GET /notices.json
  def index
    @notices = Notice.
      order("created_at DESC").
      page(params[:page])
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
      else
        format.html { render :new }
        format.json { render json: @notice.errors, status: :unprocessable_entity }
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
      else
        format.html { render :edit }
        format.json { render json: @notice.errors, status: :unprocessable_entity }
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
    @evaluation_value = 1
    @notice.add_or_update_evaluation(:opened, @evaluation_value, current_user)
  end

  def not_opened
    @evaluation_value = 0
    @notice.add_or_update_evaluation(:opened, @evaluation_value, current_user)
    render "opened"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_notice
      @notice = Notice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def notice_params
      params.require(:notice).permit(:title, :body)
    end
end
