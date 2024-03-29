class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy


  def index
  # @users = User.all
  @users = User.paginate(page: params[:page])
  end

  def show
  @user = User.find(params[:id])
  @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
  @user = User.new
  end

  def create
  @user = User.new(user_params)
  if @user.save
    @user.send_activation_email
    flash[:info] = "Please check your email to activate your account."
    redirect_to root_url
  else
    render 'new'
  end
  end

  def edit
    @user = User.find_by(id:params[:id])
  end

  def update
    @user = User.find_by(id:params[:id])
    if @user.update(user_params)
    flash[:success] = "Profile updated"
    redirect_to @user
    else
    render 'edit'
    end
  end

  def destroy
  User.find(params[:id]).destroy
  flash[:success] = "deleted"
  redirect_to users_url
  end

  def following
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private
    def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      #@userが存在する、かつ@user == current_userである場合以外はredirectされる
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
    redirect_to(root_url) unless current_user.admin?
    end


# def current_user?(user)
#   user && user == current_user
#   end

#     # 記憶トークンcookieに対応するユーザーを返す
# def current_user
#   if (user_id = session[:user_id])
#     @current_user ||= User.find_by(id: user_id)
#   elsif (user_id = cookies.signed[:user_id])
#     user = User.find_by(id: user_id)
#     if user && user.authenticated?(cookies[:remember_token])
#       log_in user
#       @current_user = user
#     end
#   end
end
