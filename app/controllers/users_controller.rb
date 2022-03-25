class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy


  def index
  # @users = User.all
  @users = User.paginate(page: params[:page])
  end

  def show
  @user = User.find(params[:id])
  end

  def new
  @user = User.new
  end

  def create
  @user = User.new(user_params)
  if @user.save
  log_in @user
    flash[:success] = "Welcome to the Sample App!"
    #@userとするとredirect_to user_url(@user)
    redirect_to @user
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

  private
    def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
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
