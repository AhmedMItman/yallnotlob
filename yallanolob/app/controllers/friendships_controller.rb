class FriendshipsController < ApplicationController

  before_action :set_friendship, only: [:show, :edit, :update]

  # GET /friendships
  # GET /friendships.json
  def index
    if current_user
        @friendships = Friendship.where(user_id: current_user.id)
      else
        	redirect_to '/users/sign_in'
        end
  end

  # GET /friendships/1
  # GET /friendships/1.json
  def show
  end

  # GET /friendships/new
  def new
    @friendship = Friendship.new
  end

  # GET /friendships/1/edit
  def edit
  end

  # POST /friendships
  # POST /friendships.json
  def create
    @searchFriend=User.find_by_email(params[:email])


    if @searchFriend == nil
      @friendship=nil
      respond_to do |format|
        format.html { redirect_to friendships_url, notice: 'Friend Not Found.' }
        format.json { render :show, status: :created, location: @friendship }
      end
    else

      @isFriendBefore=Friendship.where(user_id:current_user.id,friend_id:@searchFriend.id).exists?
      if @isFriendBefore !=false
        respond_to do |format|
          format.html { redirect_to friendships_url, notice: 'S/He is already Your Friend.' }
          format.json { render :show, status: :created, location: @friendship }
        end
      else
        @friendship = Friendship.new(user_id:current_user.id,friend_id:@searchFriend.id)
        respond_to do |format|
          if @friendship.save
            format.html { redirect_to friendships_url, notice: 'Friendship was successfully created.' }
            format.json { render :show, status: :created, location: @friendship }
          else
            format.html { render :new }
            format.json { render json: @friendship.errors, status: :unprocessable_entity }
          end
        end
      end
    end


  end

  # PATCH/PUT /friendships/1
  # PATCH/PUT /friendships/1.json
  def update
    respond_to do |format|
      if @friendship.update(friendship_params)
        format.html { redirect_to @friendship, notice: 'Friendship was successfully updated.' }
        format.json { render :show, status: :ok, location: @friendship }
      else
        format.html { render :edit }
        format.json { render json: @friendship.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /friendships/1
  # DELETE /friendships/1.json
  def destroy
    Friendship.where(friend_id:params[:id]).destroy_all
    # respond_to do |format|
    #   format.html { redirect_to friendships_url, notice: 'Friendship was successfully destroyed.' }
    #   format.json { head :no_content }
    # end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_friendship
    @friendship = Friendship.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def friendship_params
    params.require(:friendship).permit(:user_id, :friend_id)
  end
end
