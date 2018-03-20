class UserNotificationsController < ApplicationController
  before_action :set_user_notification, only: [:show, :edit, :update, :destroy]

  # GET /user_notifications
  # GET /user_notifications.json
  def index
    if current_user
    @user_notifications = UserNotification.all
  else
      redirect_to '/users/sign_in'
    end
  end

  # GET /user_notifications/1
  # GET /user_notifications/1.json
  def show
  end

  # GET /user_notifications/new
  def new
    @user_notification = UserNotification.new
  end

  # GET /user_notifications/1/edit
  def edit
  end

  # POST /user_notifications
  # POST /user_notifications.json
  def create
    @user_notification = UserNotification.new(user_notification_params)

    respond_to do |format|
      if @user_notification.save
        format.html { redirect_to @user_notification, notice: 'User notification was successfully created.' }
        format.json { render :show, status: :created, location: @user_notification }
      else
        format.html { render :new }
        format.json { render json: @user_notification.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_notifications/1
  # PATCH/PUT /user_notifications/1.json
  def update
    respond_to do |format|
      if @user_notification.update(user_notification_params)
        format.html { redirect_to @user_notification, notice: 'User notification was successfully updated.' }
        format.json { render :show, status: :ok, location: @user_notification }
      else
        format.html { render :edit }
        format.json { render json: @user_notification.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_notifications/1
  # DELETE /user_notifications/1.json
  def destroy
    @user_notification.destroy
    respond_to do |format|
      format.html { redirect_to user_notifications_url, notice: 'User notification was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_notification
      @user_notification = UserNotification.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_notification_params
      params.require(:user_notification).permit(:seen)
    end
end
