class GroupsController < ApplicationController
  before_action :check_isLogin
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  # GET /groups
  # GET /groups.json
  def index
    # @groups = Group.all
    if current_user
    @groups = Group.where(user_id: current_user.id)
  else
      redirect_to '/users/sign_in'
    end
  end

  def userfriends
    sql = "select users.email from users, friendships where users.id = friendships.friend_id and friendships.user_id=" + params['id']
    result = ActiveRecord::Base.connection.execute(sql)
    render json: result
  end

  # GET /groups
  # GET /groups.json
  def groupfriends
    @group = Group.find params['id']
    # @groups = Group.user
    # format.json { render :show, status: :created, location: @groups }
    # format.json { name =>'marei' }
    # render json: User.where(id: 2)

    # get group 20 friends
    # sql = "select users.id, users.name, users.image, users.email, groups_users.group_id from users, groups_users where groups_users.user_id = users.id and groups_users.group_id=20"
    # insert into groups_users set user_id=1, group_id=21;

    # get all friends
    # select * from friendships where user_id=2
    # select users.email from users, friendships where users.id = friendships.friend_id and friendships.user_id=2

    # check if email exists in friend lists
    # select users.email from users, friendships where users.id = friendships.friend_id and friendships.user_id=2 and users.email='mareimorsy@gmail.com';



    sql = "select users.id, users.name, users.image_file_name, users.email, groups_users.group_id from users, groups_users where groups_users.user_id = users.id and groups_users.group_id=" + params['id']
    result = ActiveRecord::Base.connection.execute(sql)
    result.each do |user|
      if user[2] == nil
        user[2] = '/images/unknown.jpg'
      else
        user[2] = User.find(user[0]).image.url(:medium);
      end
    end
    render json: result
# <%= image_tag current_user.image.url(:medium) %>

  end

  def remove_friend_from_group
    sql = "delete from groups_users where user_id = " + params['user_id'] + " and group_id = " + params['group_id']
    result = ActiveRecord::Base.connection.execute(sql)
    render json: params
  end

  def add_friend_to_group
    # sql = "delete from groups_users where user_id = " + params['user_id'] + " and group_id = " + params['group_id']
    # result = ActiveRecord::Base.connection.execute(sql)

    sql = "select users.email from users, friendships where users.id = friendships.friend_id and friendships.user_id=" + params['user_id'] + " and users.email='" + params['email'] + "'"
    result = ActiveRecord::Base.connection.execute(sql)

    if result.size == 0
      render json: {'error' => "This user is not on your friend list"}
    else
      user_id = User.find_by_email(params['email']).id
      sql = "select * from groups_users where user_id=" + user_id.to_s + " and group_id=" + params['group_id']
      result = ActiveRecord::Base.connection.execute(sql)

      if result.size == 0
         sql = "INSERT INTO groups_users(user_id, group_id) VALUES (" + user_id.to_s + ", " + params['group_id'] + ")"
         result = ActiveRecord::Base.connection.execute(sql)
         render json: {'error' => nil}
      else
        render json: {'error' => "This user already exists on that group"}
      end
    end




  end

  # GET /groups/1
  # GET /groups/1.json
  def show
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.json
  def create
    # @group = Group.create(group_params)
    # @group.save
    @group = Group.new
    puts @group
    @group.name = params['name']
    puts params['user_id']
    @group.user_id = params['user_id']

    respond_to do |format|
      if @group.save
    #     format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render :show, status: :created, location: @group }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    @group.name = params['name']
    @group.save
    respond_to do |format|
        format.json { render :show, status: :ok, location: @group }
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      # format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end
  def check_isLogin
    if !current_user
      redirect_to root_path

    end
  end
    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:name, :user_id)
    end
end
