class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :destroy]
  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all.paginate(:page => params[:page], :per_page => 3)
  end

  # GET /orders/1
  # GET /orders/1.json
  def show

    @orderInvitedFriend=FriendOrder.where(order_id:@order.id)
    @friendsLength=@orderInvitedFriend.count
    @allinvitedFriends={}
    @orderInvitedFriend.each do |friend|
    print("here")
    print(friend.friend_id)
    @user=User.find(friend.friend_id)
    @allinvitedFriends[friend.friend_id]=[@user.name, @user.image]
    end
  end

  # GET /orders/new
  def new


    @order = Order.new


    if current_user
      @friendships = Friendship.where(user_id: current_user.id)
    else
      @friendships=nil
      respond_to do |format|
        format.html { redirect_to new_user_registration_url, notice: 'You are Not loggedin.' }
      end
    end


  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create

     # print("hhhhhhhhhhhhhhhhhh"+params[:order_resturant])
    @order = Order.new(resturant:params[:order_resturant],menu:params[:order_menu],typ:params[:order_typ],statu:params[:order_statu],user_id:current_user.id)
    @order.save
    # ActionCable.server.broadcast  "notify_channel_#{current_user.id}", @order

    @isUser=User.find_by_name(params[:order_friendName])
    print(params[:order_friendName])
    if @isUser !=nil
      @isFriendBefore=Friendship.where(user_id:current_user.id,friend_id:@isUser.id).exists?(conditions = :none)
      @notify = Notification.create message: "I'm making an order, Would you like to Join me?",from: :order_friendName,  typ: "invite", orderId: @order.id
      NotificationsUser.create user_id: current_user.id, notification_id: @notify.id
      ActionCable.server.broadcast  "notify_channel_#{current_user.id}", @order
      if @isFriendBefore == true
        @orderWithFriends = FriendOrder.new(order_id:@order.id,friend_id:@isUser.id)
        @orderWithFriends.save

      end
    end



    if params[:order_allFriends] != nil
    params[:order_allFriends].each do  |f|
        print(f)
        @isUser=User.find_by_id(f)
        if @isUser != nil
          @isFriendBefore=Friendship.where(user_id:current_user.id,friend_id:f).exists?(conditions = :none)
          @notify = Notification.new( message: "I'm making an order, Would you like to Join me?",from: current_user.name,  typ: "invite", orderId: @order.id)
          @notify.save
        end
          if @isFriendBefore == true
            print(@order.id)
              @orderWithFriends = FriendOrder.new(order_id:@order.id,friend_id:f)
              # NotificationUsers.create(user_id: @orderWithFriends.friend_id, notification_id: @notify.id)
              @notify.users.push(@notify.id,current_user)
              ActionCable.server.broadcast  "notify_channel_#{f}", @notify
            @orderWithFriends.save

          end
        end
    end
    # end

  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    print("ffffffffffffffffffffffff")
    Order.where(id:params[:id]).update_all(statu:"Finished")
    # respond_to do |format|
    #   if @order.update(order_params)
    #     format.html { redirect_to @order, notice: 'Order was successfully updated.' }
    #     format.json { render :show, status: :ok, location: @order }
    #   else
    #     format.html { render :edit }
    #     format.json { render json: @order.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    FriendOrder.where(order_id:@order.id).destroy_all
    @order.destroy
    # respond_to do |format|
    #   format.html { redirect_to order_url, notice: 'Order was successfully destroyed.' }
    #   format.json { head :no_content }
    # end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:resturant, :menu, :typ, :statu, :user_id,:test)

    end
end
