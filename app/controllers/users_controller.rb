class UsersController < ApplicationController
  skip_filter :require_login, only: [:new, :create]
  before_action :set_user, except: [:index, :new, :create]
  before_action :redirect_no_user_manager, only: [:destroy]
  before_action :redirect_no_current_user, only: [:edit, :update]

  PAR_PAGE = 10

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    not_found if Invitation.invalid_token? params[:token]
    session[:new_user] = true
    session[:token] = params[:token]
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    not_found unless can_manage_users?

    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def notices
    @notices = Notice.where(user_id: @user.id)
    unless @user == current_user
      @notices = @notices.displayable
    end
    @notices = @notices.
      default_order.
      page(params[:page]).per(PAR_PAGE)
  end

  def replies
    @replies = Reply.
      where(user_id: @user.id).
      order("created_at DESC").
      page(params[:page]).per(PAR_PAGE)
  end

  def activities
    respond_to do |format|
      format.html do
        set_target_date
        @activities = Activity.
          related_user(@user).
          between_beginning_and_end_of_day(@target_date).
          default_order.
          page(params[:page]).per(PAR_PAGE)
      end
      format.json { render json: @user.activities_for_heatmap }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:nickname, :icon_url, :club_id)
    end

    def redirect_no_current_user
      not_found unless current_user == @user
    end

    def redirect_no_user_manager
      not_found unless can_manage_users?
    end

    def set_target_date
      if params[:year] && params[:month] && params[:day]
        begin
          @target_date = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
        end
      end
    end
end
