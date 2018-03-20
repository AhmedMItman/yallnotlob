class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :destroy]
  # GET /orders
  # GET /orders.json
  def index

if current_user
    @inivtedOrder = Order.joins(:friend_orders).where(friend_orders:{friend_id:current_user.id}).paginate(:page => params[:page], :per_page => 3)
    @orders = Order.where(user_id:current_user.id).paginate(:page => params[:page], :per_page => 3)
  else
      redirect_to '/users/sign_in'
    end
  end

  def join
    orderid = params['order_id']
    joinerId = params['user_id']
    puts "================================"
    @joiner = User.find_by_id(joinerId)
    puts @joiner.name
    puts "================================"
    @isJoined = Notification.find_by(from:@joiner.name,orderId: orderid,typ:'join')
    if @isJoined == nil
        sql = "select * from user_notifications, notifications where user_notifications.notification_id = notifications.id and notifications.typ = 'invite' and notifications.orderId = #{orderid} and user_id <> #{joinerId}"
        @users = ActiveRecord::Base.connection.execute(sql)
        @invitor= Notification.where(orderId: orderid,typ:'invite')
        puts @invitor[0].from
        puts "================================"
        @invitor=User.find_by_name(@invitor[0].from)
        puts @invitor.name
        @notify = Notification.create(message:"#{@joiner.name} has accepted your Invitation",from:@joiner.name ,typ:"orderOwner",orderId: orderid)
        UserNotification.create(user_id: @invitor.id,notification_id: @notify.id)
        ActionCable.server.broadcast "notify_channel_#{@invitor.id}", @notify
        puts ""


        @users.each do |user|
          @notify = Notification.create(message:"#{@joiner.name} accepted #{@invitor.name} Invitation",from:@joiner.name ,typ:"join",orderId: orderid)
          #               # puts @notify
          UserNotification.create(user_id: user[1],notification_id: @notify.id).save
          ActionCable.server.broadcast "notify_channel_#{user[1]}", @notify

        end


        render json: params
      else
      end
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
    sql = "select count(*) from notifications where typ='join' and orderId = #{@order.id}"
    @joinersNum = ActiveRecord::Base.connection.execute(sql).first()[0]
    puts @joinersNum

    end
  end

  # GET /orders/new
  def new


    @order = Order.new


    if current_user
      @friendships = Friendship.where(user_id: current_user.id)
      @allFreindinGroup = Group.all
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
    print("pppppppppppppppppppppppppppppppppppppp")
    print(params[:order_image])
    @order = Order.new(resturant:params[:order_resturant],menu:params[:order_image],typ:params[:order_typ],statu:params[:order_statu],user_id:current_user.id)
    @order.save

    @isGroup=Group.find_by_name(params[:order_friendName])

    if @isGroup != nil
      #print(@isGroup.id.to_s)

      # @allFreindinGroup = User.joins(:groups).where(groups: {name:@isGroup.name})

      sql = "select users.id from users, groups_users where groups_users.user_id = users.id and groups_users.group_id="+@isGroup.id.to_s

      @allFreindinGroup = ActiveRecord::Base.connection.execute(sql)

      print(@allFreindinGroup)
      @friendsOfGroup=[]
      @allFreindinGroup.each do |f|

        @orderWithFriends = FriendOrder.new(order_id:@order.id,friend_id:f[0])
        @orderWithFriends.save

        @friendsOfGroup.push(User.find(f[0]))

        @notify = Notification.create(message:"#{current_user.name} Invites All  The #{@isGroup.name} group Member",from:current_user.name ,typ:"invite",orderId:@order.id)
                      # puts @notify
        UserNotification.create(user_id: f[0],notification_id: @notify.id).save
        ActionCable.server.broadcast "notify_channel_#{f[0]}", @notify

      end

      # print(@allFreindinGroup)

    else

      @isUser=User.find_by_name(params[:order_friendName])

      print(params[:order_friendName])
      if @isUser !=nil
        #@isFriendBefore = FriendOrder.where(friend_id:@isUser.id , order_id:@order.id)

        # if @isOrderedBefore ==nil
         @isFriendBefore=Friendship.where(user_id:current_user.id,friend_id:@isUser.id).exists?(conditions = :none)
        if @isFriendBefore == true

          @orderWithFriends = FriendOrder.new(order_id:@order.id,friend_id:@isUser.id)
          @orderWithFriends.save
        # end
          @notify = Notification.create(message:"#{current_user.name} Invites You to join the order",from:current_user.name ,typ:"invite",orderId:@order.id)
                      # puts @notify
          UserNotification.create(user_id: @isUser.id,notification_id: @notify.id).save
          ActionCable.server.broadcast "notify_channel_#{@isUser.id}", @notify

        end
       end

      # end



    if params[:order_allFriends] != nil
    params[:order_allFriends].each do  |f|
        print(f)
        @isUser=User.find_by_id(f)

          @isFriendBefore=Friendship.where(user_id:current_user.id,friend_id:f).exists?(conditions = :none)
          if @isFriendBefore == true
            print(@order.id)
              @orderWithFriends = FriendOrder.new(order_id:@order.id,friend_id:f)

              @orderWithFriends.save
              @notify = Notification.create(message:"#{current_user.name} Invites You to join the order ",from:current_user.name ,typ:"invite",orderId:@order.id)
                            # puts @notify
              UserNotification.create(user_id: f,notification_id: @notify.id)
              ActionCable.server.broadcast "notify_channel_#{f}", @notify

      end
          # end
        end
    end
    end
    # respond_to do |format|
    #
    #   format.html { redirect_to @order, notice: 'Order was successfully created.' }
    #   format.json { render :show, status: :created, location: @order }
    #
    # end

    if @isGroup != nil
      render json: {friendsOfGroup:@friendsOfGroup}
    end


  end
  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update

    Order.where(id:params[:id]).update_all(statu:"Finished")
    print(params[:id])
    @allusers = FriendOrder.where(order_id:params[:id])

    @allusers.each do |f|
      print(f.friend_id)
      @notify = Notification.create(message:"#{current_user.name}'s Order is Done",from:current_user.name ,typ:"finished",orderId:params[:id])
                    # puts @notify

      UserNotification.create(user_id: f.friend_id,notification_id: @notify.id)
      ActionCable.server.broadcast "notify_channel_#{f.friend_id}", @notify
    end
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
    id=@order.id
    print("idddddddddddddddddddddddddddd")
    print(id)
    @allusers = FriendOrder.where(order_id:id)

    print("sssssssssssssssssssssssssssssss")
    @allusers.each do |f|
      print(f.friend_id)
      print("yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy")
      @notify = Notification.create(message:"#{current_user.name} has canceled his order",from:current_user.name ,typ:"cancel",orderId:id)
      UserNotification.create(user_id: f.friend_id,notification_id: @notify.id)
      ActionCable.server.broadcast "notify_channel_#{f.friend_id}", @notify
    end
    FriendOrder.where(order_id:@order.id).destroy_all
    Item.where(order_id:@order.id).destroy_all
    @order.destroy
    # respond_to do |format|
    #   format.html { redirect_to order_url, notice: 'Order was successfully destroyed.' }
    #   format.json { head :no_content }
    # end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order

      print(params[:id])
      print("hamdddddddddddddddddddddddddddddddddddddddddddddddddddy")

      tes = Order.find_by(id:params[:id])
      if tes !=nil
        @order = Order.find(params[:id])
      else
        flash[:notice] = 'hahahahahaha'
        # redirect_to '/'
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:resturant, :image, :typ, :statu, :user_id,:test)

    end
end
